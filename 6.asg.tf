resource "aws_iam_role" "ssm_ec2_role" {
  name = "${local.env}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "${local.env}-ssm-policy-attachment"
  roles      = [aws_iam_role.ssm_ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${local.env}-ssm-instance-profile"
  role = aws_iam_role.ssm_ec2_role.name
}

resource "aws_launch_template" "web" {
  name_prefix   = "${local.env}-web-lt"
  image_id      = "ami-0c803b171269e2d72"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.web.id]
  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  user_data = base64encode(file("user_data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.env}-web-instance"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  name             = "${local.env}-web-asg"
  desired_capacity = 3
  max_size         = 5
  min_size         = 2

  vpc_zone_identifier       = [for subnet in aws_subnet.private : subnet.id]
  target_group_arns         = [aws_lb_target_group.web_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.env}-web-asg"
    propagate_at_launch = true
  }
}
