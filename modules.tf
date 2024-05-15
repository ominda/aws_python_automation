module "vpc" {
  source          = "./vpc"
  cidr_block      = var.v_primary_cidr_block
  project         = var.v_project
  env             = var.v_environment
  public_subnets  = var.v_public_subnets
  # private_subnets = var.v_private_subnets
}

module "ec2" {
  source = "./ec2"
  project         = var.v_project
  env             = var.v_environment
  # server_count = var.v_public_accessible_server_count
  ssh_key = var.v_ssh_key_pair
  public_subnets = module.vpc.o_public_subnets
  # private_subnets = module.vpc.o_private_subnets
  vpc_id = module.vpc.o_vpc.id
  # worker_node_count = var.v_worker_node_count
  # master_node_count = var.v_master_node_count
}