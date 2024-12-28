
resource "aws_instance" "ec2instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  tags = {
    Name = var.instance_name
  }

  security_groups = [var.security_groups_id]
}

