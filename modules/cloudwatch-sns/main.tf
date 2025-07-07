resource "aws_sns_topic" "asg_notification" {
  name = "${var.env}-asg-alerts"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.asg_notification.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# CloudWatch Alarm (just to notify via email)


resource "aws_cloudwatch_metric_alarm" "group_cpu_high" {
  alarm_name          = "${var.env}-asg-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "GroupAverageCPUUtilization"
  namespace           = "AWS/AutoScaling"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "ALERT: ASG CPU > 70% (Average)"
  alarm_actions     = [aws_sns_topic.asg_notification.arn]
}
