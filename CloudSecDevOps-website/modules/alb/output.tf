output "frontend-alb_target_group_arn" {
  value = aws_lb_target_group.frontend-alb_target_group.id
}

output "Prod-Frontend-LB_arn" {
  value = aws_lb.Prod-Frontend-LB.id
}

output "frontend-alb_dns_name" {
  value = aws_lb.Prod-Frontend-LB.dns_name
}

output "frontend-alb_zone_id" {
  value = aws_lb.Prod-Frontend-LB.zone_id
}

output "Backend-alb_target_group_arn" {
  value = aws_lb_target_group.Backend-alb_target_group.id
}

output "Prod-Backenfend-LB_arn" {
  value = aws_lb.Prod-Backenfend-LB.id
}

output "Backend-alb_dns_name" {
  value = aws_lb.Prod-Backenfend-LB.dns_name
}

output "Backend-alb_zone_id" {
  value = aws_lb.Prod-Backenfend-LB.zone_id
}