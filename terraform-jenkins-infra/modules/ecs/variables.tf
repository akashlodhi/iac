variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
