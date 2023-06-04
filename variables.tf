variable "aws_region" {
  type        = string
  description = "region where vpn is configured"
}

variable "aws_access_key" {
  type        = string
  description = "Access key of AWS account"
}

variable "aws_secret_key" {
  type        = string
  description = "secret key of AWS account"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "public subnet cidr"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "private subnet cidr"
  default     = "10.0.2.0/24"
}

variable "ami_type" {
  type        = string
  description = "AMI Type"
}

variable "capacity_type" {
  type        = string
  description = "Instance capaity"
}

variable "disk_size" {
  type        = number
  description = "disk size of the instance"
}

variable "instance_type" {
  type        = list(string)
  description = "Instance type that is created"
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket name"
}

variable "dynamodb_table_name" {
  type        = string
  description = "DynamoDB table name"
}
