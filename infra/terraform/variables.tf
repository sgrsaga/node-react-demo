##### AWS VPC variables #####

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR"
}

variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region"
}

variable "public_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.101.0/24"]
  description = "Public subnets CIDR"
}

variable "private_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "Private subnets CIDR"
}
