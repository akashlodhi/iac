variable "bucket_name"{
    description = "Name of the S3 bucket"
    type        = string
}

variable "acl" {
    description = "ACL for the s3 Bucket"
    type        =  string
    default     = "private"
}

variable "environment" {
     description = "Environment tag (dev, prod, etc.)"
     type        =  string
     default     =  "dev"
}

# ECS variables
# -------------------------
variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "jenkins-demo-ecs-cluster"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}