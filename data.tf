
# ---------------------------------------------
# Existing RoboShop VPC Remote State
# ---------------------------------------------

data "terraform_remote_state" "roboshop_vpc" {
  backend = "s3"

  config = {
    bucket = "roboshop-tf-state-optimusprime"
    key    = "roboshop/dev/bootstrap/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# ---------------------------------------------
# Route 53 Public Hosted Zone
# ---------------------------------------------

data "aws_route53_zone" "optimusprime" {
  name         = "optimusprime.uno"
  private_zone = false
}

# ---------------------------------------------
# Amazon Linux 2023 AMI
# ---------------------------------------------

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# ---------------------------------------------
# Current AWS Account Identity
# ---------------------------------------------

data "aws_caller_identity" "current" {}
