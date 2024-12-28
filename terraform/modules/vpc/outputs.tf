output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public: subnet.id]
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}
