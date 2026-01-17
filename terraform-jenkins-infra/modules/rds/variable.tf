variable "db_name" {
  type = string
}

variable "engine" {
  type    = string
  default = "aurora-mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0.mysql_aurora.3.05.2"
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "environment" {
  type = string
}
