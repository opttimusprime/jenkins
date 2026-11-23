
#!/bin/bash
set -euo pipefail

# ---------------------------------------------
# Update OS and install required packages
# ---------------------------------------------

dnf update -y

dnf install -y \
  java-21-amazon-corretto \
  git \
  wget \
  curl \
  unzip \
  tar \
  gzip \
  docker \
  awscli \
  amazon-ssm-agent

# ---------------------------------------------
# Enable AWS Systems Manager
# ---------------------------------------------

systemctl enable --now amazon-ssm-agent

# ---------------------------------------------
# Install and enable Docker
# ---------------------------------------------

systemctl enable --now docker

# ---------------------------------------------
# Install Jenkins LTS
# ---------------------------------------------

wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/rpm-stable/jenkins.repo

rpm --import \
  https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key

dnf install -y jenkins

# ---------------------------------------------
# Allow Jenkins to execute Docker commands
# ---------------------------------------------

usermod -aG docker jenkins

# ---------------------------------------------
# Install kubectl for EKS
# ---------------------------------------------

ARCH=$(uname -m)

case "$ARCH" in
  x86_64) KUBECTL_ARCH="amd64" ;;
  aarch64) KUBECTL_ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

K8S_VERSION=$(curl -fsSL \
  https://dl.k8s.io/release/stable.txt)

curl -fsSL \
  "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl" \
  -o /usr/local/bin/kubectl

chmod 755 /usr/local/bin/kubectl

# ---------------------------------------------
# Install Helm
# ---------------------------------------------

curl -fsSL \
  https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
  -o /tmp/get-helm-3

chmod 700 /tmp/get-helm-3
/tmp/get-helm-3

# ---------------------------------------------
# Prepare Jenkins workspace
# ---------------------------------------------

mkdir -p /var/lib/jenkins/workspace
chown -R jenkins:jenkins /var/lib/jenkins/workspace

# ---------------------------------------------
# Start Jenkins
# ---------------------------------------------

systemctl enable --now jenkins

# ---------------------------------------------
# Verify installed tools
# ---------------------------------------------

java -version
git --version
docker --version
aws --version
kubectl version --client
helm version --short

echo "Jenkins controller installation completed."
