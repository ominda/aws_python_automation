# Create cloudwatch alarm
resource "aws_cloudwatch_metric_alarm" "r_cw_high_cpu_alarm" {
  alarm_name          = local.cw_high_cpu_alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when CPU exceeds 70%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.r_autoscaling_group.name
  }

  alarm_actions = [aws_autoscaling_policy.r_asg_scale_out_policy.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = local.cw_low_cpu_alarm_name
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Alarm when CPU drops below 20%"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.r_autoscaling_group.name
  }

  alarm_actions = [aws_autoscaling_policy.r_asg_scale_in_policy.arn]
}
