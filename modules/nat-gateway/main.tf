# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az1 
resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc    = true

  tags   = {
    Name = "nat gateway az1 eip"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az2
resource "aws_eip" "eip_for_nat_gateway_az2" {
  vpc    = true

  tags   = {
    Name = "nat gateway az2 eip"
  }
}

# create nat gateway inside public subnet az1
resource "aws_nat_gateway" "Prod-nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = var.Prod-NAT-ALB-Sbn_az1_id

  tags   = {
    Name = "Prod nat gateway az1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [var.internet_gateway]
}

# create nat gateway inside public subnet az2
resource "aws_nat_gateway" "Prod-nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = var.Prod-NAT-ALB-Sbn_az2_id

  tags   = {
    Name = "Prod nat gateway az2"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [var.internet_gateway]
}

# create webserver subnet 1 route table  
resource "aws_route_table" "Prod-webserver-RT-1" {
  vpc_id       = var.prod-vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Prod-nat_gateway_az1.id
  }

  tags       = {
    Name     = "Prod webserver RT 1"
  }
}

# create webserver subnet 2 route table  
resource "aws_route_table" "Prod-webserver-RT-2" {
  vpc_id       = var.prod-vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Prod-nat_gateway_az2.id
  }

  tags       = {
    Name     = "Prod webserver RT 2"
  }
}

# create Appserver subnet 1 route table  
resource "aws_route_table" "Prod-Appserver-RT-1" {
  vpc_id       = var.prod-vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Prod-nat_gateway_az1.id
  }

  tags       = {
    Name     = "Prod Appserver RT 1"
  }
}

# create Appserver subnet 2 route table  
resource "aws_route_table" "Prod-Appserver-RT-2" {
  vpc_id       = var.prod-vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Prod-nat_gateway_az2.id
  }

  tags       = {
    Name     = "Prod Appserver RT 2"
  }
}

# create Dbserver subnet 1 route table  
resource "aws_route_table" "Prod-dbserver-RT-1" {
  vpc_id       = var.prod-vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Prod-nat_gateway_az1.id
  }

  tags       = {
    Name     = "Prod dbserver RT 1"
  }
}

# create Dbserver subnet 2 route table  
resource "aws_route_table" "Prod-dbserver-RT-2" {
  vpc_id       = var.prod-vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Prod-nat_gateway_az2.id
  }

  tags       = {
    Name     = "Prod dbserver RT 2"
  }
}

# associate private webserver subnet az1 to "private route table1"
resource "aws_route_table_association" "Prod-webserver-Sbn_az1_route_table_association" {
  subnet_id           = var.Prod-webserver-Sbn_az1_id
  route_table_id      = aws_route_table.Prod-webserver-RT-1.id
}

# associate private subnet az2 to "private route table"
resource "aws_route_table_association" "Prod-webserver-Sbn_az2_route_table_association" {
  subnet_id           = var.Prod-webserver-Sbn_az2_id
  route_table_id      = aws_route_table.Prod-webserver-RT-2.id
}

# associate private Appserver subnet az1 to "private route table"
resource "aws_route_table_association" "Prod-Appserver-Sbn_az1_route_table_association" {
  subnet_id           = var.Prod-Appserver-Sbn_az1_id
  route_table_id      = aws_route_table.Prod-Appserver-RT-1.id
}

# associate private Appserver subnet az2 to "private route table"
resource "aws_route_table_association" "Prod-Appserverr-Sbn_az2_route_table_association" {
  subnet_id           = var.Prod-Appserver-Sbn_az2_id
  route_table_id      = aws_route_table.Prod-Appserver-RT-2.id
}

# associate private dbserver subnet az1 to "private route table"
resource "aws_route_table_association" "Prod-databbase-Sbn_az1_route_table_association" {
  subnet_id           = var.Prod-databbase-Sbn_az1_id
  route_table_id      = aws_route_table.Prod-dbserver-RT-1.id
}

# associate private dbserver subnet az2 to "private route table"
resource "aws_route_table_association" "Prod-databbase-Sbn_az2_route_table_association" {
  subnet_id           = var.Prod-databbase-Sbn_az2_id
  route_table_id      = aws_route_table.Prod-dbserver-RT-2.id
}






/* 
# create private route table az1 and add route through nat gateway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = var.prod-vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags   = {
    Name = "private route table az1"
  }
} */
/* 
# associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_association" {
  subnet_id         = var.private_app_subnet_az1_id
  route_table_id    = aws_route_table.private_route_table_az1.id
}

# associate private data subnet az1 with private route table az1
resource "aws_route_table_association" "private_data_subnet_az1_route_table_az1_association" {
  subnet_id         = var.private_data_subnet_az1_id
  route_table_id    = aws_route_table.private_route_table_az1.id
}

# create private route table az2 and add route through nat gateway az2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags   = {
    Name = "private route table az2"
  }
}

# associate private app subnet az2 with private route table az2
resource "aws_route_table_association" "private_app_subnet_az2_route_table_az2_association" {
  subnet_id         = var.private_app_subnet_az2_id
  route_table_id    = aws_route_table.private_route_table_az2.id
}

# associate private data subnet az2 with private route table az2
resource "aws_route_table_association" "private_data_subnet_az2_route_table_az2_association" {
  subnet_id         = var.private_data_subnet_az2_id
  route_table_id    = aws_route_table.private_route_table_az2.id
} */