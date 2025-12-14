##### AWS VPC variables #####
variable "vpc_name" {
  type        = string
  default     = "node-react-vpc"
  description = "VPC Name"
}

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


##### EC2 variables #####
variable "instance_type" {
  type        = string
  default     = "t2.xlarge"
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  default     = "mumbai"
  description = "AWS Key Pair name for EC2 instances"
}

variable "ami_id" {
  type        = string
  default     = "ami-02b8269d5e85954ef"
  description = "AWS AMI ID for EC2 instances"
}

variable "ec2_instance_names" {
  type        = list(string)
  default     = ["node-react-apps-1", "node-react-monitoring-1"]
  description = "EC2 instance name"
}