# Construct local variables
locals {
  base_name = "${var.project}_${var.env}"
  public_subnets = var.public_subnets
  lambda_function_name = "${local.base_name}-${var.lambda_function_name}"
}