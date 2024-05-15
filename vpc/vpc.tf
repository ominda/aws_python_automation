# Construct local variables
locals {
  base_name = "${var.project}_${var.env}"
}

# Create primary VPC
resource "aws_vpc" "r_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "${local.base_name}_vpc"
  }
}

# Create public subnets
resource "aws_subnet" "r_public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.r_vpc.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${local.base_name}_PublicSubnet-0%d", count.index+1)
  }
}

# # Create private subnets
# resource "aws_subnet" "r_private_subnets" {
#   count             = length(var.private_subnets)
#   vpc_id            = aws_vpc.r_vpc.id
#   cidr_block        = var.private_subnets[count.index]
#   availability_zone = data.aws_availability_zones.available.names[count.index]

#   tags = {
#     Name = format("${local.base_name}_PrivateSubnet-0%d", count.index+1)
#   }
# }

# Create Internet Gateway
resource "aws_internet_gateway" "r_internet_gateway" {
  vpc_id = aws_vpc.r_vpc.id

  tags = {
    Name = "${local.base_name}_igw"
  }
}

# # Create EIP
# resource "aws_eip" "r_elastic_ip" {
#   domain = "vpc"
# }

# # Create NAT Gateway
# resource "aws_nat_gateway" "r_nat_gateway" {
#   connectivity_type = "public"
#   allocation_id     = aws_eip.r_elastic_ip.id
#   subnet_id         = aws_subnet.r_public_subnets[0].id

#   tags = {
#     Name = "${local.base_name}_nat_gateway"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.r_internet_gateway]
# }

# Create public route table
resource "aws_route_table" "r_public_route_table" {
  vpc_id = aws_vpc.r_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.r_internet_gateway.id
  }

  tags = {
    Name = "${local.base_name}_public_rbt"
  }
}

# # Create private route table
# resource "aws_route_table" "r_private_route_table" {
#   vpc_id = aws_vpc.r_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.r_nat_gateway.id
#   }

#   tags = {
#     Name = "${local.base_name}_private_rbt"
#   }
# }

# Subnet, Route table association
resource "aws_route_table_association" "r_Public_subnet_association" {
  # for_each = aws_subnet.r_public_subnets : subnet.id => aws_subnet.r_public_subnets[subnet.id].cidr_block
  count = "${length(var.public_subnets)}"
  # subnet_id      = aws_subnet.r_public_subnets[*].id
  route_table_id = aws_route_table.r_public_route_table.id
  subnet_id     = "${element(aws_subnet.r_public_subnets.*.id, count.index)}"
}

# resource "aws_route_table_association" "r_private_subnet_association" {
#   count = length(var.private_subnets)
#   subnet_id      = element(aws_subnet.r_private_subnets.*.id, count.index)
#   route_table_id = aws_route_table.r_private_route_table.id
# }