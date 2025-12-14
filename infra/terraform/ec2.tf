# EC2 Instances
resource "aws_instance" "ec2_instances" {
  count = length(var.ec2_instance_names)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_security_group.security_group_id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 100
    volume_type = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "${var.ec2_instance_names[count.index]}"
  }
}


