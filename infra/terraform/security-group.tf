# Public Security Group - Open for public access
module "public_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.vpc_name}-public-sg"
  description = "Public security group open for public access"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all TCP traffic from public"
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all UDP traffic from public"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ICMP traffic from public"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name = "${var.vpc_name}-public-sg"
  }
}

# Private Security Group - Only allowed from public security group
module "private_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "${var.vpc_name}-private-sg"
  description = "Private security group only allowed from public security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 65535
      protocol                 = "tcp"
      source_security_group_id = module.public_security_group.security_group_id
      description              = "Allow TCP traffic from public security group"
    },
    {
      from_port                = 0
      to_port                  = 65535
      protocol                 = "udp"
      source_security_group_id = module.public_security_group.security_group_id
      description              = "Allow UDP traffic from public security group"
    },
    {
      from_port                = -1
      to_port                  = -1
      protocol                 = "icmp"
      source_security_group_id = module.public_security_group.security_group_id
      description              = "Allow ICMP traffic from public security group"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name = "${var.vpc_name}-private-sg"
  }
}
