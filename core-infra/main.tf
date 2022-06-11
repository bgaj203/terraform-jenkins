resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-vpc-igw"
  }
}

resource "aws_route_table" "main-route-table-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "10.0.2.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "10.0.3.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main-rout-table"
  }
}

resource "aws_subnet" "subnet-2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name  = "main-subnet-ap-southeast-2a"
    Owner = "main-vpc"
  }
}

resource "aws_subnet" "subnet-2b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name  = "main-subnet-ap-southeast-2a"
    Owner = "main-vpc"
  }
}

resource "aws_subnet" "subnet-2c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name  = "main-subnet-ap-southeast-2a"
    Owner = "main-vpc"
  }
}

resource "aws_route_table_association" "ap-southeast-2a" {
  subnet_id      = aws_subnet.subnet-2a.id
  route_table_id = aws_route_table.main-route-table-table.id
}

resource "aws_route_table_association" "ap-southeast-2b" {
  subnet_id      = aws_subnet.subnet-2b.id
  route_table_id = aws_route_table.main-route-table-table.id
}

resource "aws_route_table_association" "ap-southeast-2c" {
  subnet_id      = aws_subnet.subnet-2c.id
  route_table_id = aws_route_table.main-route-table-table.id
}

resource "aws_security_group" "internet-access" {
  name        = "internet-access"
  description = "Allow HTTP HTTPS SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "internet-access"
  }
}