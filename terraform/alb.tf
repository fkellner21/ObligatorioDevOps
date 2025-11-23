resource "aws_lb" "main" {
    name               = "ecs-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

    tags = {
        Name = "ecs-alb"
    }
}

resource "aws_lb_target_group" "api_gateway" {
    name        = "tg-${var.ecs_service_name_api_gateway}"
    port        = 8000
    protocol    = "HTTP"
    vpc_id      = aws_vpc.main.id
    target_type = "ip"

    health_check {
        enabled             = true
        healthy_threshold   = 2
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
    }

    tags = {
        Name = "tg-${var.ecs_service_name_api_gateway}"
    }
}

resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.main.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type = "fixed-response"

        fixed_response {
        content_type = "text/plain"
        status_code  = "404"
        message_body = "Not Found"
        }
    }
}

resource "aws_lb_listener_rule" "api_gateway" {
    listener_arn = aws_lb_listener.front_end.arn
    priority     = 30

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.api_gateway.arn
    }

    condition {
        path_pattern {
        values = ["/*"]
        }
    }
}