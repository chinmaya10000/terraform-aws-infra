resource "aws_launch_template" "web" {
  name_prefix   = "${var.env}-web-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.web_sg_id]
  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    name = var.instance_profile
  }

  user_data = base64encode(file("user_data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-web-instance"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  name             = "${var.env}-web-asg"
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  vpc_zone_identifier       = var.private_subnets
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-web-asg"
    propagate_at_launch = true
  }

  # Enable CloudWatch detailed metrics for better monitoring
  metrics_granularity = "1Minute"
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
}

# Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "${var.env}-cpu-target-tracking"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.web.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value     = 50
    disable_scale_in = false
  }
}
