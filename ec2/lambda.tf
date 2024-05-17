
data "archive_file" "d_auto_scaller_lambda" {
  type        = "zip"
  source_file = "${path.module}/scripts/auto_scaller.py"
  output_path = "${path.module}/scripts/auto_scaller.zip"
}

resource "aws_lambda_function" "r_auto_scaller_lambda" {
  function_name = local.lambda_function_name
  role = aws_iam_role.r_iam_role_lambda.arn
  filename      = data.archive_file.d_auto_scaller_lambda.output_path
  handler = "auto_scaller.lambda_handler"
  runtime = var.python_runtime
  timeout = 300

  # Advanced logging controls (optional)
  logging_config {
    log_format = "Text"
    log_group = aws_cloudwatch_log_group.r_cloudwatch_loggroup_lambda.name
  }

#   environment {
#     variables = {
#       ALART_NAME = 
#     }
#   }

  # ... other configuration ...
  depends_on = [
    aws_iam_role_policy_attachment.r_cloudwatch_lambda_logs,
    aws_cloudwatch_log_group.r_cloudwatch_loggroup_lambda,
  ]
}

resource "aws_iam_policy" "r_cloudwatch_logging_lambda" {
  name        = "${local.base_name}-lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.d_pd_cloudwatch_lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "r_cloudwatch_lambda_logs" {
  role       = aws_iam_role.r_iam_role_lambda.name
  policy_arn = aws_iam_policy.r_cloudwatch_logging_lambda.arn
}

