############################
# IAM ROLE FOR JENKINS (BOOTSTRAP)
############################

resource "aws_iam_role" "jenkins_exec_role" {
  name = "jenkins-terraform-exec-role"

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
# IAM POLICY (INFRA CREATION)
############################

resource "aws_iam_policy" "jenkins_exec_policy" {
  name = "jenkins-terraform-exec-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # EC2 / Networking / SG / EBS
      {
        Effect = "Allow"
        Action = [
          "ec2:*"
        ]
        Resource = "*"
      },

      # ECS / Fargate / ECR
      {
        Effect = "Allow"
        Action = [
          "ecs:*",
          "ecr:*"
        ]
        Resource = "*"
      },

      # ALB / NLB
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:*"
        ]
        Resource = "*"
      },

      # RDS
      {
        Effect = "Allow"
        Action = [
          "rds:*"
        ]
        Resource = "*"
      },

      # S3 (state + buckets)
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = "*"
      },

      # IAM (required by Terraform)
      {
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRole",
          "iam:ListRoles",
          "iam:PassRole"
        ]
        Resource = "*"
      },

      # CloudWatch (logs, metrics)
      {
        Effect = "Allow"
        Action = [
          "logs:*",
          "cloudwatch:*"
        ]
        Resource = "*"
      }
    ]
  })
}

############################
# ATTACH POLICY TO ROLE
############################

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.jenkins_exec_role.name
  policy_arn = aws_iam_policy.jenkins_exec_policy.arn
}

############################
# INSTANCE PROFILE
############################

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-terraform-profile"
  role = aws_iam_role.jenkins_exec_role.name
}
