variable "instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name for Jenkins"
  type        = string
  default     = "stark_jenkins"
}


variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

################################
# S3 VARIABLES (USED BY S3 MODULE)
################################

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "acl" {
  description = "ACL for the S3 bucket"
  type        = string
  default     = "private"
}

variable "environment" {
  description = "Environment name (dev / qa / prod)"
  type        = string
  default     = "dev"
}