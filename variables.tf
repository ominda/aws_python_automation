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

# variable "v_private_subnets" {
#   type = list(string)
# }

# EC2 variables
# variable "v_public_accessible_server_count" {
#   type = number  
# }

variable "v_ssh_key_pair" {
  type = string  
}

# variable "v_worker_node_count" {
#   type = number
# }

# variable "v_master_node_count" {
#   type = number
# }