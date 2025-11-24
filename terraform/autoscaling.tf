# Target de Auto Scaling para el servicio API Gateway
resource "aws_appautoscaling_target" "api_gateway" {
  max_capacity       = 2  
  min_capacity       = 1  
  resource_id        = "service/$$ {aws_ecs_cluster.main.name}/ $${aws_ecs_service.api_gateway.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Política de Scaling para CPU (scale out/in basado en CPU)
resource "aws_appautoscaling_policy" "api_gateway_cpu" {
  name               = "api-gateway-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.api_gateway.resource_id
  scalable_dimension = aws_appautoscaling_target.api_gateway.scalable_dimension
  service_namespace  = aws_appautoscaling_target.api_gateway.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0  
    scale_in_cooldown  = 60    
    scale_out_cooldown = 60    
  }
}

# Target de Auto Scaling para el servicio Inventory
resource "aws_appautoscaling_target" "inventory_service" {
  max_capacity       = 2
  min_capacity       = 1  
  resource_id        = "service/$$ {aws_ecs_cluster.main.name}/ $${aws_ecs_service.inventory_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


# Política de Scaling para CPU (scale out/in basado en CPU)
resource "aws_appautoscaling_policy" "inventory_service_cpu" {
  name               = "inventory-service-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.inventory_service.resource_id
  scalable_dimension = aws_appautoscaling_target.inventory_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.inventory_service.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0  
    scale_in_cooldown  = 60    
    scale_out_cooldown = 60    
  }
}

# Target de Auto Scaling para el servicio product
resource "aws_appautoscaling_target" "product_service" {
  max_capacity       = 2
  min_capacity       = 1  
  resource_id        = "service/$$ {aws_ecs_cluster.main.name}/ $${aws_ecs_service.product_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


# Política de Scaling para CPU (scale out/in basado en CPU)
resource "aws_appautoscaling_policy" "product_service_cpu" {
  name               = "product-service-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.product_service.resource_id
  scalable_dimension = aws_appautoscaling_target.product_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.product_service.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0  
    scale_in_cooldown  = 60    
    scale_out_cooldown = 60    
  }
}