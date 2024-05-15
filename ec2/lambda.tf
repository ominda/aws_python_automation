
data "archive_file" "d_auto_scaller_lambda" {
  type        = "zip"
  source_file = "${path.module}/scripts/auto_scaller.py"
  output_path = "${path.module}/scripts/auto_scaller.zip"
}

resource "aws_lambda_function" "r_auto_scaller_lambda" {
  function_name = "ec2_auto_scaller"
  role = aws_iam_role.r_iam_role_lambda.arn
  filename      = data.archive_file.d_auto_scaller_lambda.output_path
  handler = "auto_scaller.lambda_handler"
  runtime = "python3.9"
  timeout = 300

  # Advanced logging controls (optional)
  logging_config {
    log_format = "Text"
  }

  # ... other configuration ...
  depends_on = [
    aws_iam_role_policy_attachment.r_lambda_logs,
    aws_cloudwatch_log_group.r_cloudwatch_loggroup_lambda,
  ]
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "r_cloudwatch_loggroup_lambda" {
  name              = "/aws/lambda/ec2_auto_scaller"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_group.r_cloudwatch_loggroup_lambda.arn}:*"]
  }
}

resource "aws_iam_policy" "r_cloudwatch_logging_lambda" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "r_lambda_logs" {
  role       = aws_iam_role.r_iam_role_lambda.name
  policy_arn = aws_iam_policy.r_cloudwatch_logging_lambda.arn
}

resource "aws_iam_role" "r_iam_role_lambda" {
  name = "ec2AutoScallerLambdaRole"
  assume_role_policy = data.aws_iam_policy_document.d_pd_lambda_role_assume_policy.json
}