variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a"]
}
