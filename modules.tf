module "vpc" {
  source         = "./vpc"
  cidr_block     = var.v_primary_cidr_block
  project        = var.v_project
  env            = var.v_environment
  public_subnets = var.v_public_subnets
  # private_subnets = var.v_private_subnets
}

# module "ec2" {
#   source               = "./ec2"
#   project              = var.v_project
#   env                  = var.v_environment
#   ssh_key              = var.v_ssh_key_pair
#   public_subnets       = module.vpc.o_public_subnets
#   vpc_id               = module.vpc.o_vpc.id
#   instance_type        = var.v_ec2_instance_type
#   cw_alarm             = var.v_ec2_cw_alarm
#   comparison_operator  = var.v_ec2_cw_comparison_operator
#   metric_name          = var.v_ec2_cw_metric_name
#   name_space           = var.v_ec2_cw_name_space
#   alarm_description    = var.v_ec2_cw_alarm_description
#   lambda_function_name = var.v_ec2_lambda_function_name
#   python_runtime       = var.v_ec2_python_runtime
# }

module "autoscaler" {
  source         = "./autoscaler"
  project        = var.v_project
  env            = var.v_environment
  ssh_key        = var.v_ssh_key_pair
  public_subnets = module.vpc.o_public_subnets
  vpc_id         = module.vpc.o_vpc.id
  instance_type  = var.v_ec2_instance_type
}