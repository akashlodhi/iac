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

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
  default     = "jenkins-ecs-cluster"
}

# ALB
##########################
variable "alb_name" {
  description = "ALB Name"
  type        = string
}

##########################
# RDS
##########################
variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "master_username" {
  description = "RDS master username"
  type        = string
}

variable "master_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

# VPC & Subnets
##########################
variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs (for ALB)"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs (for RDS, ECS tasks)"
  type        = list(string)
}
