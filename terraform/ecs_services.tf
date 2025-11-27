resource "aws_ecs_service" "servicios" {
    name            = "servicios"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.tarea_principal.arn
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
        Name = "servicios"
    }

    lifecycle {
        ignore_changes = [desired_count]
    }
}