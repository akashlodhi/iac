############################
# OUTPUTS FOR JENKINS EC2
############################

# Public IP of the EC2 instance
output "jenkins_public_ip_iac" {
  description = "Public IP of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_iac.public_ip
}

# Public DNS of the EC2 instance
output "jenkins_public_dns_iac" {
  description = "Public DNS of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_iac.public_dns
}

# Jenkins UI URL
output "jenkins_url_iac" {
  description = "URL to access Jenkins UI"
  value       = "http://${aws_instance.jenkins_iac.public_ip}:8080"
}
