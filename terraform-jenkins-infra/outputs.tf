# Public IP of the EC2 instance
output "jenkins_public_ip" {
  description = "Public IP of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_iac.public_ip
}

# Public DNS of the EC2 instance
output "jenkins_public_dns" {
  description = "Public DNS of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_iac.public_dns
}

# Jenkins UI URL
output "jenkins_url" {
  description = "URL to access Jenkins UI"
  value       = "http://${aws_instance.jenkins_iac.public_ip}:8080"
}