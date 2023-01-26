output "bastionHost_security_group_id" {
  value = aws_security_group.bastionHost_security_group.id
}

output "frontend-lb_security_group_id" {
  value = aws_security_group.frontend-lb_security_group.id
}

output "webserver_security_group_id" {
  value = aws_security_group.webserver_security_group.id
}

output "backend-alb_security_group_id" {
  value = aws_security_group.backend-alb_security_group.id
}

output "appserver_security_group_id" {
  value = aws_security_group.appserver_security_group.id
}

output "database_security_group_id" {
  value = aws_security_group.database_security_group.id
}
