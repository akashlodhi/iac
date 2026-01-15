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
