############################
# SECURITY GROUP
############################

resource "aws_security_group" "jenkins_sg_iac" {
  name_prefix = "jenkins-sg-iac-"
  description = "Allow SSH and Jenkins UI"
  vpc_id     = var.vpc_id   # strongly recommended if not already present

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


############################
# EC2 INSTANCE WITH JENKINS
############################

resource "aws_instance" "jenkins_iac" {
  ami                         = "ami-03f4878755434977f" # Ubuntu 22.04 ap-south-1
  instance_type               = "t3.medium"
  key_name                    = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group._new.id]

  # 👇 IMPORTANT: Instance profile created by bootstrap
  iam_instance_profile = "jenkins-terraform-profile"

  user_data = <<-EOF
    #!/bin/bash
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
