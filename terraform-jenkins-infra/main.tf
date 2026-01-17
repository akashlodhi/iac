########################################
# DATA SOURCE: DEFAULT VPC
########################################

data "aws_vpc" "default" {
  default = true
}

########################################
# SECURITY GROUP FOR JENKINS
########################################

resource "aws_security_group" "jenkins_sg_iac" {
  name_prefix = "jenkins-sg-iac-"
  description = "Allow SSH and Jenkins UI"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg-iac"
  }
}

########################################
# EC2 INSTANCE WITH JENKINS
########################################

resource "aws_instance" "jenkins_iac" {
  ami                         = "ami-03f4878755434977f" # Ubuntu 22.04 (ap-south-1)
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.jenkins_sg_iac.id
  ]

  # IAM instance profile created by BOOTSTRAP
  iam_instance_profile = "jenkins-terraform-profile"

  user_data = <<-EOF
    #!/bin/bash
    set -e

    apt-get update -y
    apt-get install -y openjdk-17-jdk curl gnupg ca-certificates

    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
      tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | \
      tee /etc/apt/sources.list.d/jenkins.list > /dev/null

    apt-get update -y
    apt-get install -y jenkins

    systemctl enable jenkins
    systemctl start jenkins
  EOF

  tags = {
    Name = "jenkins-server-iac"
  }
}

############################
# S3 BUCKET MODULE
############################

module "s3_bucket" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
  acl         = var.acl
  environment = var.environment
}

module "ecs_cluster" {
  source       = "./modules/ecs"
  cluster_name = var.ecs_cluster_name
  environment  = var.environment
}

module "alb" {
  source      = "./modules/alb"
  alb_name    = "jenkins-demo-alb"
  vpc_id      = var.vpc_id
  subnet_ids  = var.public_subnet_ids
  environment = var.environment
}

module "rds" {
  source          = "./modules/rds"
  db_name         = "jenkinsdb"
  master_username = "admin"
  master_password = var.db_password
  subnet_ids      = var.private_subnet_ids
  vpc_id          = var.vpc_id
  environment     = var.environment
}
