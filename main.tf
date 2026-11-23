
# ---------------------------------------------
# Jenkins Controller Security Group
# ---------------------------------------------

resource "aws_security_group" "jenkins_controller" {
  name        = "${var.project}-${var.environment}-jenkins-controller-sg"
  description = "Jenkins controller security group"
  vpc_id      = data.terraform_remote_state.roboshop_vpc.outputs.vpc_id

  ingress {
    description = "Jenkins UI from my IP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-jenkins-controller-sg"
  }
}

# ---------------------------------------------
# Jenkins Controller EC2 Instance
# ---------------------------------------------

resource "aws_instance" "jenkins_controller" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "c7i-flex.large"
  subnet_id                   = data.terraform_remote_state.roboshop_vpc.outputs.public_subnets[0]
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.jenkins_controller.id
  ]

  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  user_data_replace_on_change = true

  user_data = templatefile(
    "${path.module}/userdata/jenkins-controller.sh",
    {
      project     = var.project
      environment = var.environment
      aws_region  = var.aws_region
    }
  )

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project}-${var.environment}-jenkins-controller"
  }
}

# ---------------------------------------------
# Route 53 DNS Record
# ---------------------------------------------

resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.optimusprime.zone_id
  name    = var.jenkins_dns_name
  type    = "A"
  ttl     = 60

  records = [
    aws_instance.jenkins_controller.public_ip
  ]
}
