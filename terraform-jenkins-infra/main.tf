############################
# IAM ROLE FOR JENKINS EC2
############################

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-ec2-role"

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
}

############################
# IAM POLICY
############################

resource "aws_iam_policy" "jenkins_policy" {
  name = "jenkins-basic-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "s3:*",
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

############################
# ATTACH POLICY TO ROLE
############################

resource "aws_iam_role_policy_attachment" "jenkins_policy_attach" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = aws_iam_policy.jenkins_policy.arn
}

############################
# INSTANCE PROFILE
############################

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}

############################
# SECURITY GROUP
############################

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg-iac"
  description = "Allow SSH and Jenkins UI"

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
}

############################
# EC2 INSTANCE WITH JENKINS
############################

resource "aws_instance" "jenkins" {
  ami                         = "ami-03f4878755434977f" # Ubuntu 22.04 (ap-south-1)
  instance_type               = "t2.micro"
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile  = aws_iam_instance_profile.jenkins_profile.name

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y openjdk-17-jdk

    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null

    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install -y jenkins
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
  EOF

  tags = {
    Name = "jenkins-server-iac"
  }
}


