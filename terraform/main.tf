# Define local variable for instance details
locals {
  instances = {
    Master = {
      name = "Master"
      instance_type="t3.micro"
    }
    Slave = {
      name = "Slave"
      instance_type="t3.medium"
    }
  }
}
# Define vpc  
module "vpc" {
  source = "./modules/vpc"
  vpc_name      = "ivolve"
  cidr_block    = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24"]
}

module "ec2_instance" {
  for_each         = local.instances
  source           = "./modules/Ec2"
  ami_id           = "ami-0e2c8caa4b6378d8c"
  instance_type    = each.value.instance_type
  subnet_id        = module.vpc.public_subnets[0]      
  key_name         = "Ec2Key"        
  instance_name    = each.value.name
  security_groups_id = aws_security_group.ec2_sg.id
  associate_public_ip_address = true  
}


