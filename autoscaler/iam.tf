# Instance Role for SSM 
resource "aws_iam_role" "r_asg_iam_instance_role" {
  name                = local.asg_instance_role_name
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  assume_role_policy  = data.aws_iam_policy_document.d_pd_asg_instance_role_assume_policy.json
}

# Create iam instance profile
resource "aws_iam_instance_profile" "r_asg_iam_instance_profile" {
    name = local.asg_instance_profile_name
    role = aws_iam_role.r_asg_iam_instance_role.name  
}