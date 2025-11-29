resource "aws_cloudwatch_dashboard" "main" {
    dashboard_name = "Dashboard"

    dashboard_body = jsonencode({
        widgets = [
            {
                type = "metric",
                x    = 0, y = 0, width = 12, height = 6,
                properties = {
                    title = "CPU Utilization ECS",
                    metrics = [
                        ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.main.name, "ServiceName", aws_ecs_service.servicios.name]
                    ],
                    stat   = "Average",
                    period = 300,
                    view   = "timeSeries",
                    region = var.aws_region
                }
            },
            {
                type = "metric",
                x    = 12, y = 0, width = 12, height = 6,
                properties = {
                    title = "Memory Utilization ECS",
                    metrics = [
                        ["AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.main.name, "ServiceName", aws_ecs_service.servicios.name]
                    ],
                    stat   = "Average",
                    period = 300,
                    view   = "timeSeries",
                    region = var.aws_region
                }
            },
            {
                type = "metric",
                x    = 0, y = 6, width = 12, height = 6,
                properties = {
                    title = "Latency ALB",
                    metrics = [
                        ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.main.arn_suffix]
                    ],
                    stat   = "Average",
                    period = 300,
                    view   = "timeSeries",
                    region = var.aws_region
                }
            },
            {
                type = "metric",
                x    = 12, y = 6, width = 12, height = 6,
                properties = {
                    title = "Requests ALB",
                    metrics = [
                        ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.main.arn_suffix]
                    ],
                    stat   = "Sum",
                    period = 300,
                    view   = "timeSeries",
                    region = var.aws_region
                }
            },
            {
                type = "metric",
                x    = 0, y = 12, width = 12, height = 6,
                properties = {
                    title = "Healthy Host Count ALB",
                    metrics = [
                        ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", aws_lb.main.arn_suffix, "TargetGroup", aws_lb_target_group.api_gateway.arn_suffix]
                    ],
                    stat   = "Average",
                    period = 300,
                    view   = "timeSeries",
                    region = var.aws_region
                }
            },
            {
                type = "metric",
                x    = 12, y = 12, width = 12, height = 6,
                properties = {
                    title = "HTTP 5xx Errors ALB",
                    metrics = [
                        ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", aws_lb.main.arn_suffix]
                    ],
                    stat   = "Sum",
                    period = 300,
                    view   = "timeSeries",
                    region = var.aws_region
                }
            }
        ]
    })
}