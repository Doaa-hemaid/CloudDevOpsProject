resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = toset(var.public_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = element(var.availability_zones, index(var.public_subnets, each.value))
  tags = {
    Name = "${var.vpc_name}-public-subnet-${index(var.public_subnets, each.value) + 1}"
  }
}

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = element(var.availability_zones, index(var.private_subnets, each.value))
  tags = {
    Name = "${var.vpc_name}-private-${index(var.private_subnets, each.value) + 1}"
  }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# Public route for Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}