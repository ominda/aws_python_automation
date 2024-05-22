# Instance Role for SSM 
resource "aws_iam_role" "r_iam_instance_role" {
  name                = "instanceProfileRole"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  assume_role_policy  = data.aws_iam_policy_document.d_pd_instance_role_assume_policy.json
}

# Create iam instance profile
resource "aws_iam_instance_profile" "r_iam_instance_profile" {
    name = "SSM-instance-profile"
    role = aws_iam_role.r_iam_instance_role.name  
}

# Create iam role for Lambda
resource "aws_iam_role" "r_iam_role_lambda" {
  name = "ec2AutoScallerLambdaRole"
  assume_role_policy = data.aws_iam_policy_document.d_pd_lambda_role_assume_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AutoScalingFullAccess", aws_iam_policy.r_cloudwatch_logging.arn, aws_iam_policy.r_lambda_execution.arn]
}