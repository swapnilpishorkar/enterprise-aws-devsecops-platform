output "repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.app.name
}

output "repository_url" {
  description = "ECR repository URL for Docker image pushes and pulls"
  value       = aws_ecr_repository.app.repository_url
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.app.arn
}
