variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# ECS Cluster
variable "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
  default     = "cluster_obl_devops"
}

# ECS Services Names
variable "ecs_service_name_api_gateway" {
  description = "ECS Service name for api-gateway"
  type        = string
  default     = "api-gateway-service"
}

variable "ecs_service_name_product_service" {
  description = "ECS Service name for product-service"
  type        = string
  default     = "product-service"
}

variable "ecs_service_name_inventory_service" {
  description = "ECS Service name for inventory-service"
  type        = string
  default     = "inventory-service"
}

# ECR Repository Names
variable "ecr_repository_name_api_gateway" {
  description = "Name of API Gateway ECR repository"
  type        = string
  default     = "api-gateway-repository"
}

variable "ecr_repository_name_product_service" {
  description = "Name of Product Service ECR repository"
  type        = string
  default     = "product-service-repository"
}

variable "ecr_repository_name_inventory_service" {
  description = "Name of Inventory Service ECR repository"
  type        = string
  default     = "inventory-service-repository"
}

# Desired count for all ECS services
variable "ecs_desired_count" {
  description = "Number of tasks to run for each ECS service"
  type        = number
  default     = 1
}

variable "project_prefix" {
  type    = string
  default = "obl"
}

variable "db_name" {
  type    = string
  default = "app_db"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "Admin1234!"
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "redis_node_type" {
  type    = string
  default = "cache.t3.micro"
}
