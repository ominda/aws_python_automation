terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.45.0"
    }
  }
}

provider "aws" {
  region = var.v_region
  default_tags {
    tags = {
      Project     = var.v_project
      Environment = var.v_environment
      Owner       = var.v_owner
      Identifier  = var.v_identifier
    }
  }
}