
data "archive_file" "d_auto_scaller_lambda" {
  type        = "zip"
  source_file = "${path.module}/scripts/auto_scaller.py"
  output_path = "${path.module}/scripts/auto_scaller.zip"
}

resource "aws_lambda_function" "r_auto_scaller_lambda" {
  function_name = local.lambda_function_name
  role = aws_iam_role.r_iam_role_lambda.arn
  filename      = data.archive_file.d_auto_scaller_lambda.output_path
  source_code_hash = data.archive_file.d_auto_scaller_lambda.output_base64sha256
  handler = "auto_scaller.lambda_handler"
  runtime = var.python_runtime
  timeout = 300

  # Advanced logging controls (optional)
  logging_config {
    log_format = "Text"
    log_group = aws_cloudwatch_log_group.r_cloudwatch_loggroup.name
  }

      environment {
        variables = {
          AMI_ID = data.aws_ami.d_ubuntu_amis.id
          INSTANCE_TYPE = var.instance_type
          KEY_NAME = var.ssh_key
          SECURITY_GROUP_ID = aws_security_group.r_public_default_sg.id
          SUBNET_ID = local.public_subnets["public_subnet-01"]
        }
      }

  # ... other configuration ...
  depends_on = [
    # aws_iam_role_policy_attachment.r_cloudwatch_lambda_logs,
    aws_cloudwatch_log_group.r_cloudwatch_loggroup,
  ]
}

resource "aws_iam_policy" "r_cloudwatch_logging" {
  name        = "${local.base_name}-cw_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.d_pd_cloudwatch_policy.json
}

# resource "aws_iam_role_policy_attachment" "r_cloudwatch_lambda_logs" {
#   role       = aws_iam_role.r_iam_role_lambda.name
#   policy_arn = aws_iam_policy.r_cloudwatch_logging_lambda.arn
# }

resource "aws_iam_policy" "r_lambda_execution" {
  name        = "${local.base_name}-lambda_execution"
  path        = "/"
  description = "IAM policy for execution lambda"
  policy      = data.aws_iam_policy_document.d_pd_lambda_execution_policy.json  
}

resource "aws_lambda_permission" "r_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.r_auto_scaller_lambda.function_name
  principal     = "lambda.alarms.cloudwatch.amazonaws.com"
  source_arn    = aws_cloudwatch_metric_alarm.r_cloudwatch_alarm_ec2.arn
}