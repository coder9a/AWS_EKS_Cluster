variable "AWS_Region" {
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

variable "VPC_CIDR" {
  type        = string
  description = "vpc cidr"
}

variable "Public_Subnet_CIDR" {
  type        = string
  description = "public subnet cidr"
}

variable "Private_Subnet_CIDR" {
  type        = string
  description = "private subnet cidr"
}

variable "AMI_Type" {
  type        = string
  description = "AMI Type"
}

variable "Capacity_Type" {
  type        = string
  description = "Instance capaity"
}

variable "Disk_Size" {
  type        = number
  description = "disk size of the instance"
}

variable "EC2_Instance_Type" {
  type        = list(string)
  description = "Instance type that is created"
  default = [ "t2.micro" ]
}

variable "Project" {
  type        = string
  description = "Project name"
}

variable "Worker_Node_Count" {
  type        = number
  description = "Number of worker nodes to created"
}

variable "Max_Node_Count" {
  type        = number
  description = "Maximum number of worker nodes"
}

variable "Min_Node_Count" {
  type        = number
  description = "Minimum number of worker nodes"
}

