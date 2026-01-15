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