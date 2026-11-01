output "vpc_id" {
  description = "Development VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Development public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "internet_gateway_id" {
  description = "Development Internet Gateway ID"
  value       = module.vpc.internet_gateway_id
}

output "private_subnet_ids" {
  description = "Development private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "private_route_table_id" {
  description = "Development private route table ID"
  value       = module.vpc.private_route_table_id
}

output "alb_security_group_id" {
  description = "Development ALB security group ID"
  value       = module.security_groups.alb_security_group_id
}

output "app_security_group_id" {
  description = "Development application security group ID"
  value       = module.security_groups.app_security_group_id
}

output "eks_cluster_role_arn" {
  description = "Development EKS cluster IAM role ARN"
  value       = module.iam.eks_cluster_role_arn
}

output "eks_node_role_arn" {
  description = "Development EKS node IAM role ARN"
  value       = module.iam.eks_node_role_arn
}

output "ecr_repository_name" {
  description = "Development ECR repository name"
  value       = module.ecr.repository_name
}

output "ecr_repository_url" {
  description = "Development ECR repository URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "Development ECR repository ARN"
  value       = module.ecr.repository_arn
}
