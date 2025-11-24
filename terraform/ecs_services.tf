resource "aws_ecs_service" "api_gateway" {
    name            = var.ecs_service_name_api_gateway
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.api_gateway.arn
    desired_count   = var.ecs_desired_count
    launch_type     = "FARGATE"
    
    network_configuration {
        security_groups  = [aws_security_group.ecs_tasks.id]
        subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
        assign_public_ip = false
    }
    
    load_balancer {
        target_group_arn = aws_lb_target_group.api_gateway.arn
        container_name   = "api-gateway"
        container_port   = 8000
    }
    
    depends_on = [aws_lb_listener.front_end]
    
    tags = {
        Name = var.ecs_service_name_api_gateway
    }

    lifecycle {
        ignore_changes = [desired_count]
    }
}

resource "aws_ecs_service" "product_service" {
    name            = var.ecs_service_name_product_service
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.product_service.arn
    desired_count   = var.ecs_desired_count
    launch_type     = "FARGATE"
    
    network_configuration {
        security_groups  = [aws_security_group.ecs_tasks.id]
        subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
        assign_public_ip = false
    }
    
    tags = {
        Name = var.ecs_service_name_product_service
    }

    lifecycle {
        ignore_changes = [desired_count]
    }
}

resource "aws_ecs_service" "inventory_service" {
    name            = var.ecs_service_name_inventory_service
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.inventory_service.arn
    desired_count   = var.ecs_desired_count
    launch_type     = "FARGATE"
    
    network_configuration {
        security_groups  = [aws_security_group.ecs_tasks.id]
        subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
        assign_public_ip = false
    }
    
    tags = {
        Name = var.ecs_service_name_inventory_service
    }

    lifecycle {
        ignore_changes = [desired_count]
    }
}