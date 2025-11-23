resource "aws_ecs_task_definition" "api_gateway" {
    family                   = var.ecs_service_name_api_gateway
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512"
    execution_role_arn       = data.aws_iam_role.lab_role.arn

    container_definitions = jsonencode([
        {
        name        = "api-gateway"
        image       = "${aws_ecr_repository.api_gateway.repository_url}:latest"
        essential   = true
        portMappings = [
            {
            containerPort = 8000
            hostPort      = 8000
            protocol      = "tcp"
            }
        ]
        environment = [
            { 
                name = "PRODUCT_SERVICE_URL", 
                value = "http://product-service:8002" 
            },
            { 
                name = "INVENTORY_SERVICE_URL", 
                value = "http://inventory-service:8001" 
            },
            {
                name  = "REDIS_URL"
                value = "${aws_elasticache_cluster.redis.cache_nodes[0].address}:6379"
            }
        ]
        }
    ])

    tags = {
        Name = var.ecs_service_name_api_gateway
    }
}

resource "aws_ecs_task_definition" "product_service" {
    family                   = var.ecs_service_name_product_service
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512"
    execution_role_arn       = data.aws_iam_role.lab_role.arn

    container_definitions = jsonencode([
        {
        name      = "product-service"
        image     = "${aws_ecr_repository.product_service.repository_url}:latest"
        essential = true

        portMappings = [
            {
            containerPort = 8002
            hostPort      = 8002
            protocol      = "tcp"
            }
        ]

        environment = [
            {
                name  = "DATABASE_URL"
                value = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.postgres.endpoint}/${var.db_name}"            },
            {
                name  = "REDIS_URL"
                value = "redis://${aws_elasticache_cluster.redis.cache_nodes[0].address}:6379"
            }
        ]

        logConfiguration = {
            logDriver = "awslogs"
            options = {
                awslogs-group         = "/ecs/product-service"
                awslogs-region        = var.aws_region
                awslogs-stream-prefix = "ecs"
            }
        }
        }
    ])

    tags = {
        Name = var.ecs_service_name_product_service
    }
}

resource "aws_ecs_task_definition" "inventory_service" {
    family                   = var.ecs_service_name_inventory_service
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "256"
    memory                   = "512"
    execution_role_arn       = data.aws_iam_role.lab_role.arn

    container_definitions = jsonencode([
        {
        name      = "inventory-service"
        image     = "${aws_ecr_repository.inventory_service.repository_url}:latest"
        essential = true

        portMappings = [
            {
            containerPort = 8001
            hostPort      = 8001
            protocol      = "tcp"
            }
        ]

        environment = [
            {
                name  = "DATABASE_URL"
                value = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.postgres.endpoint}/${var.db_name}"
            },
            {
                name  = "REDIS_URL"
                value = "${aws_elasticache_cluster.redis.cache_nodes[0].address}:6379"
            }
        ]

        logConfiguration = {
            logDriver = "awslogs"
            options = {
                "awslogs-group"         = "/ecs/inventory-service"
                "awslogs-region"        = var.aws_region
                "awslogs-stream-prefix" = "ecs"
            }
        }
        }
    ])

    tags = {
        Name = var.ecs_service_name_inventory_service
    }
}