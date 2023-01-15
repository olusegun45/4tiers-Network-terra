# create security group for the BastionHost application
resource "aws_security_group" "bastionHost_security_group" {
  name        = "BastionHost security group"
  description = "enable ssh access on port 22"
  vpc_id      = var.prod-vpc_id

  ingress {
    description      = "http access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "BastionHost security group"
  }
}

# create security group for the frontend/External application load balancer
resource "aws_security_group" "frontend-lb_security_group" {
  name        = "frontend-lb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.prod-vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "frontend-lb security group"
  }
}

# create security group for the webserver
resource "aws_security_group" "webserver_security_group" {
  name        = "webserver security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.prod-vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.frontend-lb_security_group.id}"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.frontend-lb_security_group.id}"]
  }

  ingress {
    description      = "http access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.bastionHost_security_group.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "webserver security group"
  }
}

# create security group for the Backend application load balancer
resource "aws_security_group" "backend-alb_security_group" {
  name        = "backend-alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.prod-vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.webserver_security_group.id}"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.webserver_security_group.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "backend-alb security group"
  }
}

# create security group for the Appserver
resource "aws_security_group" "appserver_security_group" {
  name        = "Appserver security group"
  description = "enable http/https/ssh access on port 80/443/22"
  vpc_id      = var.prod-vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.backend-alb_security_group.id}"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.backend-alb_security_group.id}"]
  }

  ingress {
    description      = "http access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.bastionHost_security_group.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Appserver security group"
  }
}

# create security group for the Database
resource "aws_security_group" "database_security_group" {
  name        = "Database security group"
  description = "enable access on port 3306"
  vpc_id      = var.prod-vpc_id

  ingress {
    description      = "http access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.appserver_security_group.id}"]
  }

  ingress {
    description      = "https access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.bastionHost_security_group.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Database security group"
  }
}