locals {
  az_names    = data.aws_availability_zones.azs.names
  pub_sub_ids = aws_subnet.sharks_public_subnet.*.id
}

resource "aws_subnet" "sharks_public_subnet" {
  count                   = length(local.az_names)
  vpc_id                  = aws_vpc.sharks_vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sharks_vpc.id

  tags = {
    Name = "Sharks-IGW"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.sharks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Sharks-PublicRT"
  }
}


resource "aws_route_table_association" "pub_sub_association" {
  count          = length(local.az_names)
  subnet_id      = local.pub_sub_ids[count.index]
  route_table_id = aws_route_table.publicrt.id
}
