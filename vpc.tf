# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, { Name = "${var.prefix}-vpc" })
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.prefix}-igw" })
}

# Public subnet 1 in AZ1
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.prefix}-public-az1"
    Tier = "public"
  })
}

# Public subnet 2 in AZ2
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.prefix}-public-az2"
    Tier = "public"
  })
}

# Private subnet in AZ3 (not used for instances; created for deliverables)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = merge(local.common_tags, {
    Name = "${var.prefix}-private-az3"
    Tier = "private"
  })
}

# Public route table with IGW default route
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.prefix}-rtb-public" })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_assoc2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# Private route table (no default route; remains isolated)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.prefix}-rtb-private" })
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}