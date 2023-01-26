output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "prod-vpc_id" {
  value = aws_vpc.prod-vpc.id
}

output "Prod-NAT-ALB-Sbn_az1_id" {
  value = aws_subnet.Prod-NAT-ALB-Sbn_az1.id
}

output "Prod-NAT-ALB-Sbn_az2_id" {
  value = aws_subnet.Prod-NAT-ALB-Sbn_az2.id
}

output "Prod-webserver-Sbn_az1_id" {
  value = aws_subnet.Prod-webserver-Sbn_az1.id
}

output "Prod-webserver-Sbn_az2_id" {
  value = aws_subnet.Prod-webserver-Sbn_az2.id
}

output "Prod-Appserver-Sbn_az1_id" {
  value = aws_subnet.Prod-Appserver-Sbn_az1.id
}

output "Prod-Appserver-Sbn_az2_id" {
  value = aws_subnet.Prod-Appserver-Sbn_az2.id
}

output "Prod-databbase-Sbn_az1_id" {
  value = aws_subnet.Prod-databbase-Sbn_az1.id
}

output "Prod-databbase-Sbn_az2_id" {
  value = aws_subnet.Prod-databbase-Sbn_az2.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}