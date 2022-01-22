resource "aws_subnet" "sharks_private_subnet" {
  count             = length(slice(local.az_names, 0, 2))
  vpc_id            = aws_vpc.sharks_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.az_names))
  availability_zone = local.az_names[count.index]

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}

resource "aws_eip" "nat_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = local.pub_sub_ids[0]

  tags = {
    Name = "SharksNAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}



resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.sharks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Sharks-PrivateRT"
  }
}

resource "aws_route_table_association" "private_sub_association" {
  count          = length(slice(local.az_names, 0, 2))
  subnet_id      = aws_subnet.sharks_private_subnet.*.id[count.index]
  route_table_id = aws_route_table.privatert.id
}
