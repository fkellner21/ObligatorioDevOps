output "load_balancer_url" {
  description = "URL of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "ecr_repository_url_api_gateway" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.api_gateway.repository_url
}

output "ecr_repository_url_product_service" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.product_service.repository_url
}

output "ecr_repository_url_inventory_service" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.inventory_service.repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name_api_gateway" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.api_gateway.name
}

output "ecs_service_name_product_service" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.product_service.name
}

output "ecs_service_name_inventory_service" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.inventory_service.name
}

output "database_host" {
  value = aws_db_instance.postgres.endpoint
}

output "database_url" {
  value = "postgres://${var.db_username}:${var.db_password}@${aws_db_instance.postgres.endpoint}/${var.db_name}"
  sensitive = true
}