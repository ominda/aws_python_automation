# Cloudwatch alarm for EC2  CPU utilization
resource "aws_cloudwatch_metric_alarm" "r_cloudwatch_alarm_ec2" {
  alarm_name                = "ec2_cpu_utilization_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions = [aws_lambda_function.r_auto_scaller_lambda.arn]
  dimensions = {
        InstanceId = aws_instance.r_public_ec2_instances.id
      }
}