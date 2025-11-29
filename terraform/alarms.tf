resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "ecs-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 80
  period              = 150
  statistic           = "Average"

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.servicios.name
  }

  alarm_description = "CPU Utilization ECS more than 80% in 2 periods"
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name          = "ecs-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 80
  period              = 150
  statistic           = "Average"

  metric_name = "MemoryUtilization"
  namespace   = "AWS/ECS"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.servicios.name
  }

  alarm_description = "Memory Utilization ECS more than 80% in 2 periods"
}

resource "aws_cloudwatch_metric_alarm" "alb_healthy_host_low" {
  alarm_name          = "alb-healthy-host-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 300
  statistic           = "Average"

  metric_name = "HealthyHostCount"
  namespace   = "AWS/ApplicationELB"

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
    TargetGroup  = aws_lb_target_group.api_gateway.arn_suffix
  }

  alarm_description = "Healthy Host Count of the Target Group is 0"
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_high" {
  alarm_name          = "alb-target-5xx-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 5
  period              = 300
  statistic           = "Sum"

  metric_name = "HTTPCode_Target_5XX_Count"
  namespace   = "AWS/ApplicationELB"

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  alarm_description = "The ALB has more than 5 5XX errors in 5 minutes"
}