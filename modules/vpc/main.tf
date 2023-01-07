# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidir
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet-1 az1
resource "aws_subnet" "public_subnet-1_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet-1_az1_cidir
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet-1_az1"
  }
}

# create public subnet-2 az1
resource "aws_subnet" "public_subnet-2_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet-2_az1_cidir
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet-2_az1"
  }
}

# create public subnet-1 az2
resource "aws_subnet" "public_subnet-1_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet-1_az2_cidir
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet-1_az2"
  }
}

# create public subnet-2 az2
resource "aws_subnet" "public_subnet-2_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet-2_az2_cidir
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet-2_az2"
  }
}

# create route table 1 and add public route 1
resource "aws_route_table" "public_route_table-1" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "public route table 1"
  }
}

# associate public subnet-1 az1 to "public route table 1"
resource "aws_route_table_association" "public_subnet-1_az1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet-1_az1.id
  route_table_id      = aws_route_table.public_route_table-1.id
}

# associate public subnet-2 az1 to "public route table 1"
resource "aws_route_table_association" "public_subnet-2_az1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet-2_az1.id
  route_table_id      = aws_route_table.public_route_table-1.id
}

# create route table 2 and add public route 2
resource "aws_route_table" "public_route_table-2" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "public route table 2"
  }
}

# associate public subnet-1 az2 to "public route table-2"
resource "aws_route_table_association" "public_subnet-1_az2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet-1_az2.id
  route_table_id      = aws_route_table.public_route_table-2.id
}

# associate public subnet-2 az2 to "public route table-2"
resource "aws_route_table_association" "public_subnet-2_az2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet-2_az2.id
  route_table_id      = aws_route_table.public_route_table-2.id
}

# create private app subnet az1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_app_subnet_az1_cidir
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private_app_subnet_az1"
  }
}

# create private app subnet az2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_app_subnet_az2_cidir
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private_app_subnet_az2"
  }
}

# create private data subnet az1
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_az1_cidir
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private_data_subnet_az1"
  }
}

# create private data subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_az2_cidir
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private_data_subnet_az2"
  }
}