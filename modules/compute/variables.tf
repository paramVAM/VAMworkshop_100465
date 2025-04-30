# Compute module - variables.tf

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of subnets where instances will be created"
  type        = list(string)
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (example)
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = null
}