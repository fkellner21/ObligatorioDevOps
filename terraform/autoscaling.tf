# Target de Auto Scaling para el servicio API Gateway
resource "aws_appautoscaling_target" "scaling_service" {
  max_capacity       = 2  
  min_capacity       = 1  
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.servicios.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Política de Scaling para CPU (scale out/in basado en CPU)
resource "aws_appautoscaling_policy" "services_cpu" {
  name               = "services-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.scaling_service.resource_id
  scalable_dimension = aws_appautoscaling_target.scaling_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.scaling_service.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0  
    scale_in_cooldown  = 60    
    scale_out_cooldown = 60    
  }
}






