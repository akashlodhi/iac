output "jenkins_iam_role_name" {
  value = aws_iam_role.jenkins_terraform_role.name
}

output "jenkins_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins_instance_profile.name
}
