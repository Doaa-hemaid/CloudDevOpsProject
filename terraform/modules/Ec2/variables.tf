variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "The subnet ID where the instance will be created"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair to use"
  type        = string
}

variable "instance_name" {
  description = "The name tag for the EC2 instance"
  type        = string
  default     = "web-server"
}
variable "security_groups_id" {
  description = "The ID of the VPC to associate resources with"
  type        = string
}
variable "associate_public_ip_address" {
  description = "Flag to associate a public IP address with the instance"
  type        = bool
  default     = true
}
