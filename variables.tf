variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1" # Mumbai
}

variable "prefix" {
  description = "Team/project prefix"
  type        = string
  default     = "TerraformTitans" # as requested
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnets (each in a different AZ)
variable "public_subnet1_cidr" {
  description = "Public subnet 1 CIDR (AZ1)"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet2_cidr" {
  description = "Public subnet 2 CIDR (AZ2)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR (AZ3)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "ASG min size"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "ASG max size"
  type        = number
  default     = 4
}