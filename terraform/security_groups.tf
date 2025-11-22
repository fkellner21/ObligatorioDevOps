resource "aws_security_group" "alb" {
    name        = "alb-sg"
    description = "Security group for Application Load Balancer"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        description = "HTTP from anywhere"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "alb-sg"
    }
}

resource "aws_security_group" "redis" {
  name        = "redis-sg"
  description = "Security group for ElastiCache Redis"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Redis from ECS tasks"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks.id]  # Permite desde ECS tasks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg"
  }
}

resource "aws_security_group" "ecs_tasks" {
    name        = "ecs-tasks-sg"
    description = "Security group for ECS tasks"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        description     = "Allow traffic from ALB"
        from_port       = 8000
        to_port         = 8000
        protocol        = "tcp"
        security_groups = [aws_security_group.alb.id]
    }
    
    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "ecs-tasks-sg"
    }
}

resource "aws_cloudwatch_log_group" "product_service" {
  name              = "/ecs/product-service"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "inventory_service" {
  name              = "/ecs/inventory-service"
  retention_in_days = 7
}