/* Terraform module for creating front and back end load balancers: */

# create frontend application load balancer
resource "aws_lb" "Prod-Frontend-LB" {
  name               = "${var.project_name}-frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.frontend-lb_security_group_id]
  subnets            = [var.Prod-NAT-ALB-Sbn_az1_id, var.Prod-NAT-ALB-Sbn_az2_id]
  enable_deletion_protection = false

  tags   = {
    Name = "${var.project_name}-frontend-alb"
  }
}

# create target group
resource "aws_lb_target_group" "frontend-alb_target_group" {
  name        = "${var.project_name}-Frontend-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.prod-vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "frontend-alb_http_listener" {
  load_balancer_arn = aws_lb.Prod-Frontend-LB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# create a listener on port 443 with forward action
resource "aws_lb_listener" "frontend-alb_https_listener" {
  load_balancer_arn  = aws_lb.Prod-Frontend-LB.arn
  port               = 443
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-alb_target_group.arn
  }
}

# create Backend application load balancer
resource "aws_lb" "Prod-Backenfend-LB" {
  name               = "${var.project_name}-Backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.backend-alb_security_group_id]
  subnets            = [var.Prod-webserver-Sbn_az1_id, var.Prod-webserver-Sbn_az2_id]
  enable_deletion_protection = false

  tags   = {
    Name = "${var.project_name}-Backend-alb"
  }
}

# create target group
resource "aws_lb_target_group" "Backend-alb_target_group" {
  name        = "${var.project_name}-Backend-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.prod-vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "Backend-alb_http_listener" {
  load_balancer_arn = aws_lb.Prod-Backenfend-LB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# create a listener on port 443 with forward action
resource "aws_lb_listener" "Backen-alb_https_listener" {
  load_balancer_arn  = aws_lb.Prod-Backenfend-LB.arn
  port               = 443
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Backend-alb_target_group.arn
  }
}




























/* output "lb_dns_name" {
  value = aws_elb.example.dns_name
}

resource "aws_elb" "example" {
  name               = "example"
  availability_zones = ["us-west-2a", "us-west-2b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  instances                   = ["${aws_instance.example.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
}


# Load balancer module
resource "aws_lb" "Prod-front_end-LB" {
  security_groups = [module.frontend-lb_security_group.id]
  subnets         = [module.vpc.Prod-NAT-ALB-Sbn_az1, module.vpc.Prod-NAT-ALB-Sbn_az2]
  internal        = false

  tags      = {
    Name    = "Prod front end LB"
  }
}

resource "aws_lb" "Prod-back_end-LB" {
  internal        = true
  security_groups = [module.backend-alb_security_group_id]
  subnets         = [module.vpc.Prod-webserver-Sbn_az1, module.vpc.Prod-webserver-Sbn_az2]

  tags      = {
    Name    = "Prod back end LB"
  }
}

# Target groups and listeners
resource "aws_lb_target_group" "Frontend-LB-HTTP-TG" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.prod-vpc_id

  tags      = {
    Name    = "Frontend LB HTTP TG"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.Prod-front_end-LB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Frontend-LB-HTTP-TG.arn
  }
}

resource "aws_lb_target_group" "Backend-LB-HTTP-TG" {
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.prod-vpc_id

  tags      = {
    Name    = "Backend LB HTTP TG"
  }
}

resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.Prod-back_end-LB.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Backend-LB-HTTP-TG.arn
  }
}


 resource "aws_lb" "example" {
  name               = "example"
  internal           = true
  security_groups    = [aws_security_group.example.id]
  subnets            = [module.vpc.subnet_ids[0],module.vpc.subnet_ids[1]]
}
This module creates two load balancers, one for the front end and one for the back end. 
It uses the VPC and security group modules to specify the VPC and security group to use 
for the load balancers. The front end load balancer is created as an external load balancer 
and the back end load balancer is created as an internal load balancer.

Note that this is just an example and may not include all of the necessary resources or 
configurations for your specific use case. You may need to customize the module to fit 
your needs.

 ====================================================================

 # ALB for the web servers
resource "aws_lb" "prod-front-lb" {
  name               = format("%s-alb", var.vpc_name)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnet_id     = var.public_subnet-1_az1_id
  enable_http2       = false
  enable_deletion_protection = false

  tags = {
    Name = format("%s-alb", var.vpc_name)
  }
}

# Target group for the web servers
resource "aws_lb_target_group" "web_servers" {
  name     = "sharepoint-web-servers-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_servers.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }
}

# Find the target group
data "aws_lb_target_group" "web_servers" {
  name = "sharepoint-web-servers-tg"
}

# Attach an EC2 instance to the target group on port 80
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.arn
  target_id        = aws_instance.web.id
  port             = 80
}  */