
# ---------------------------------------------
# AWS Region
# ---------------------------------------------

variable "aws_region" {
  description = "AWS region for Jenkins infrastructure"
  type        = string
}

# ---------------------------------------------
# Project Name
# ---------------------------------------------

variable "project" {
  description = "Project name"
  type        = string
}

# ---------------------------------------------
# Environment
# ---------------------------------------------

variable "environment" {
  description = "Deployment environment"
  type        = string
}

# ---------------------------------------------
# EC2 Key Pair
# ---------------------------------------------

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

# ---------------------------------------------
# Jenkins Access IP
# ---------------------------------------------

variable "my_ip_cidr" {
  description = "Public IPv4 CIDR allowed to access Jenkins"
  type        = string

  # validation {
  #   condition = (
  #     can(cidrnetmask(var.my_ip_cidr)) &&
  #     var.my_ip_cidr != "0.0.0.0/0"
  #   )
  #   error_message = "Provide a valid IPv4 CIDR other than 0.0.0.0/0."
  # }
}

# ---------------------------------------------
# Jenkins DNS Name
# ---------------------------------------------

variable "jenkins_dns_name" {
  description = "Route 53 DNS name for Jenkins"
  type        = string
  default     = "jenkins.optimusprime.uno"
}
