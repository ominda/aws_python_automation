variable "v_region" {
  type    = string
  default = "us-east-1"
}

variable "v_project" {
  type = string
}

variable "v_environment" {
  type = string
}

variable "v_owner" {
  type = string
}

variable "v_identifier" {
  type = string
}

# VPC variables
variable "v_primary_cidr_block" {
  type = string
}

# Public subnets
variable "v_public_subnets" {
  type = list(string)
}

# EC2 variables
variable "v_ec2_instance_type" {
  type = string
}
variable "v_ssh_key_pair" {
  type = string
}

# Cloud Watch variables
variable "v_ec2_cw_alarm" {
  type = string
}

variable "v_ec2_cw_comparison_operator" {
  type = string
}

variable "v_ec2_cw_metric_name" {
  type = string
}

variable "v_ec2_cw_name_space" {
  type = string
}

variable "v_ec2_cw_alarm_description" {
  type = string
}

# Lambda variables
variable "v_ec2_lambda_function_name" {
  type = string
}

variable "v_ec2_python_runtime" {
  type = string
}