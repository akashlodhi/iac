output "jenkins_instance_profile_name" {
  description = "Instance profile to attach to Jenkins EC2"
  value       = aws_iam_instance_profile.jenkins_profile.name
}

output "jenkins_exec_role_arn" {
  description = "IAM role assumed by Jenkins EC2 for Terraform execution"
  value       = aws_iam_role.jenkins_exec_role.arn
}
