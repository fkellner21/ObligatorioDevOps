variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_name_api_gateway" {
  description = "Name of the ECR repository"
  type        = string
  default     = "api-gateway"
}

variable "ecr_repository_name_product_service" {
  description = "Name of the ECR repository"
  type        = string
  default     = "product-service"
}

variable "ecr_repository_name_inventory_service" {
  description = "Name of the ECR repository"
  type        = string
  default     = "inventory-service"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "my-cluster"
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "my-service"
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "web-app"
}
