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

resource "aws_iam_policy" "jenkins_exec_policy" {
  name = "jenkins-terraform-exec-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:*",
        "ecs:*",
        "elasticloadbalancing:*",
        "rds:*",
        "s3:*",
        "iam:PassRole"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.jenkins_exec_role.name
  policy_arn = aws_iam_policy.jenkins_exec_policy.arn
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-terraform-profile"
  role = aws_iam_role.jenkins_exec_role.name
}
