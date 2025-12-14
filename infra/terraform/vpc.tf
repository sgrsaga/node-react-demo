module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = ["${var.aws_region}a"]
  public_subnets  = var.public_subnets_cidr

  public_subnet_tags = {
    "apps/external" = "true"
  }

  private_subnet_tags = {
    "apps/internal" = "true"
  }
}
