module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr
  
  public_subnet_tags = {
    "apps/external" = "true"
  }

  private_subnet_tags = {
    "apps/internal" = "true"
  }
}
