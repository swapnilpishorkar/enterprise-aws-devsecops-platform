output "alb_security_group_id" {
  description = "Security group ID for the public ALB"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "Security group ID for private application workloads"
  value       = aws_security_group.app.id
}
