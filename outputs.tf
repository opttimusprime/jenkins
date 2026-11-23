
# ---------------------------------------------
# VPC Output
# ---------------------------------------------

output "roboshop_vpc_id" {
  value = data.terraform_remote_state.roboshop_vpc.outputs.vpc_id
}

# ---------------------------------------------
# Jenkins Controller Private IP
# ---------------------------------------------

output "jenkins_controller_private_ip" {
  value = aws_instance.jenkins_controller.private_ip
}

# ---------------------------------------------
# Jenkins Controller Public IP
# ---------------------------------------------

output "jenkins_controller_public_ip" {
  value = aws_instance.jenkins_controller.public_ip
}

# ---------------------------------------------
# Jenkins IAM Role ARN
# ---------------------------------------------

output "jenkins_role_arn" {
  value = aws_iam_role.jenkins_role.arn
}

# ---------------------------------------------
# Jenkins URL
# ---------------------------------------------

output "jenkins_url" {
  value = "http://${aws_route53_record.jenkins.fqdn}:8080"
}
