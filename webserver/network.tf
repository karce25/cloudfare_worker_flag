#VPC

resource "aws_vpc" "first" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "first_vpc"
  }
}

#Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.first.id

  tags = {
    Name = "first_igw"
  }
}

#Subnet

resource "aws_subnet" "mgmt" {
  vpc_id     = aws_vpc.first.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "mgmt"
  }
}


#route table just added

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.first.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}




#Security group
#Inbound

resource "aws_security_group" "inbound" {
  name        = "inbound"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.first.id

  tags = {
    Name = "allow_inbound"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_tls" {
  security_group_id = aws_security_group.inbound.id
  cidr_ipv4         = aws_vpc.first.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.inbound.id
  cidr_ipv4         = aws_vpc.first.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.inbound.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
