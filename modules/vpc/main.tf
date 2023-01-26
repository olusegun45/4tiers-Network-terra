# create vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block              = var.prod-vpc_cidir
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-prod-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.prod-vpc.id

  tags      = {
    Name    = "${var.project_name}-prod-vpc-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1 for Prod-NAT-ALB
resource "aws_subnet" "Prod-NAT-ALB-Sbn_az1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.Prod-NAT-ALB-Sbn_az1_cidir
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Prod-NAT-ALB-Sbn_az1"
  }
}

# create public subnet az2 for Prod-NAT-ALB
resource "aws_subnet" "Prod-NAT-ALB-Sbn_az2" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.Prod-NAT-ALB-Sbn_az2_cidir
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Prod-NAT-ALB-Sbn_az2"
  }
}

# create Prod-webserver subnet az1
resource "aws_subnet" "Prod-webserver-Sbn_az1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.Prod-webserver-Sbn_az1_cidir
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Prod-webserver-Sbn_az1"
  }
}

# create Prod-webserver subnet az2
resource "aws_subnet" "Prod-webserver-Sbn_az2" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = var.Prod-webserver-Sbn_az2_cidir
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Prod-webserver-Sbn_az2"
  }
}

# create Prod-Appserver subnet az1
resource "aws_subnet" "Prod-Appserver-Sbn_az1" {
  vpc_id                   = aws_vpc.prod-vpc.id
  cidr_block               = var.Prod-Appserver-Sbn_az1_cidir
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Prod-Appserver-Sbn_az1"
  }
}

# create Prod-Appserver subnet az2
resource "aws_subnet" "Prod-Appserver-Sbn_az2" {
  vpc_id                   = aws_vpc.prod-vpc.id
  cidr_block               = var.Prod-Appserver-Sbn_az2_cidir
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Prod-Appserver-Sbn_az2"
  }
}

# create Prod-databbase subnet az1
resource "aws_subnet" "Prod-databbase-Sbn_az1" {
  vpc_id                   = aws_vpc.prod-vpc.id
  cidr_block               = var.Prod-databbase-Sbn_az1_cidir
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Prod-databbase-Sbn_az1"
  }
}

# create Prod-databbase subnet az2
resource "aws_subnet" "Prod-databbase-Sbn_az2" {
  vpc_id                   = aws_vpc.prod-vpc.id
  cidr_block               = var.Prod-databbase-Sbn_az2_cidir
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Prod-databbase-Sbn_az2"
  }
}

# create  Prod-NAT-ALB-Puplic route table 1 and add public route 1
resource "aws_route_table" "Prod-NAT-ALB-Puplic-RT-1" {
  vpc_id       = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "Prod NAT ALB Puplic RT1"
  }
}

# create  Prod-NAT-ALB-Puplic route table 2 and add public route 2
resource "aws_route_table" "Prod-NAT-ALB-Puplic-RT-2" {
  vpc_id       = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "Prod NAT ALB Puplic RT2"
  }
}

# associate Prod-NAT-ALB-Puplic route table 1 to Prod-NAT-ALB subnet az1
resource "aws_route_table_association" "Prod-NAT-ALB-Sbn_az1_route_table_association" {
  subnet_id           = aws_subnet.Prod-NAT-ALB-Sbn_az1.id
  route_table_id      = aws_route_table.Prod-NAT-ALB-Puplic-RT-1.id
}

# associate Prod-NAT-ALB-Puplic route table 2 to Prod-NAT-ALB subnet az2
resource "aws_route_table_association" "Prod-NAT-ALB-Sbn_az2_route_table_association" {
  subnet_id           = aws_subnet.Prod-NAT-ALB-Sbn_az2.id
  route_table_id      = aws_route_table.Prod-NAT-ALB-Puplic-RT-2.id
}