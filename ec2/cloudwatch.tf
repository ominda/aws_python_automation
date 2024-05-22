# Cloudwatch alarm for EC2  CPU utilization
resource "aws_cloudwatch_metric_alarm" "r_cloudwatch_alarm_ec2" {
  alarm_name                = "${local.base_name}-${var.cw_alarm}"
  comparison_operator       = var.comparison_operator
  evaluation_periods        = 2
  metric_name               = var.metric_name
  namespace                 = var.name_space
  period                    = 120
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = var.alarm_description
  insufficient_data_actions = []
  alarm_actions = [aws_lambda_function.r_auto_scaller_lambda.arn]
  ok_actions = [aws_lambda_function.r_auto_scaller_lambda.arn]
  dimensions = {
        InstanceId = aws_instance.r_public_ec2_instances.id
      }
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "r_cloudwatch_loggroup" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 3
}