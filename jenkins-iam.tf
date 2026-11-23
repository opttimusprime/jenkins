
# ---------------------------------------------
# Jenkins EC2 IAM Role
# ---------------------------------------------

resource "aws_iam_role" "jenkins_role" {
  name = "${var.project}-${var.environment}-jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project}-${var.environment}-jenkins-role"
  }
}

# ---------------------------------------------
# ECR Permissions
# Docker image push and pull
# ---------------------------------------------

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# ---------------------------------------------
# AWS Systems Manager
# EC2 administration through Session Manager
# ---------------------------------------------

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ---------------------------------------------
# EKS Cluster Discovery
# Required for aws eks update-kubeconfig
# ---------------------------------------------

resource "aws_iam_role_policy" "jenkins_eks_describe" {
  name = "${var.project}-${var.environment}-jenkins-eks-describe-policy"
  role = aws_iam_role.jenkins_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster"
        ]

        Resource = "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${var.project}-${var.environment}-eks"
      }
    ]
  })
}

# ---------------------------------------------
# Jenkins EC2 Instance Profile
# ---------------------------------------------

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.project}-${var.environment}-jenkins-profile"
  role = aws_iam_role.jenkins_role.name
}
