# Subnet group para RDS - usar tus subnets privadas
resource "aws_db_subnet_group" "postgres" {
    name       = "microservices-db-subnet-group"
    subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    
    tags = {
        Name = "Microservices DB Subnet Group"
    }
}

# Security Group para RDS
resource "aws_security_group" "rds" {
    name        = "microservices-rds-sg"
    description = "Security group for RDS PostgreSQL"
    vpc_id      = aws_vpc.main.id
    
    ingress {
        description     = "PostgreSQL from ECS tasks"
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        security_groups = [aws_security_group.ecs_tasks.id]
    }

    ingress {
        description     = "PostgreSQL from Lambda"
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        security_groups = [aws_security_group.lambda.id]
    }
    
    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "microservices-rds-sg"
    }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres" {
    identifier           = "microservices-db-instance"
    engine               = "postgres"
    instance_class       = "db.t3.micro"
    parameter_group_name = aws_db_parameter_group.no_ssl.name
    allocated_storage    = 20
    storage_type         = "gp2"
    
    db_name              = var.db_name
    username             = var.db_username
    password             = var.db_password
    
    db_subnet_group_name   = aws_db_subnet_group.postgres.name
    vpc_security_group_ids = [aws_security_group.rds.id]
    
    publicly_accessible     = false
    skip_final_snapshot     = true
    backup_retention_period = 0
    
    tags = {
        Name = "Microservices DB Instance"
    }
}

resource "null_resource" "lambda_package" {
  triggers = {
    init_py  = filesha256("${path.module}/lambda_init/init.py")
    init_sql = filesha256("${path.module}/lambda_init/init.sql")
    # Forzamos recreación si cambia cualquier archivo en la carpeta
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Construyendo paquete Lambda para init-db..."
      rm -rf "${path.module}/lambda_init_package" "${path.module}/lambda_init.zip"
      mkdir -p "${path.module}/lambda_init_package"
      cp -r "${path.module}/lambda_init/"* "${path.module}/lambda_init_package/"
      pip install pg8000 --target "${path.module}/lambda_init_package" --quiet --no-cache-dir
      cd "${path.module}"
      zip -r -q lambda_init.zip lambda_init_package/
      echo "lambda_init.zip creado correctamente"
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      rm -rf "${path.module}/lambda_init_package" "${path.module}/lambda_init.zip"
    EOT
  }
}

# === 2. Archivo ZIP que ya existe físicamente (nunca falla) ===
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_init_package"
  output_path = "${path.module}/lambda_init.zip"

  # Esto es lo importante: espera a que el null_resource termine
  depends_on = [null_resource.lambda_package]
}

data "aws_caller_identity" "current" {}

# === 3. Lambda que usa el ZIP ya creado ===
resource "aws_lambda_function" "init_db_lambda" {
  function_name = "init-db-lambda"
  runtime       = "python3.11"
  handler       = "init.handler"
  role          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout = 60

  vpc_config {
    subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      DATABASE_URL = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.postgres.endpoint}/${var.db_name}"
    }
  }

  depends_on = [aws_db_instance.postgres, null_resource.lambda_package]
}

# Security Group para Lambda
resource "aws_security_group" "lambda" {
    name        = "microservices-lambda-sg"
    description = "Security group for Lambda function"
    vpc_id      = aws_vpc.main.id
    
    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "microservices-lambda-sg"
    }
}

# Ejecutar Lambda para inicializar DB
resource "null_resource" "run_db_init" {
    depends_on = [aws_lambda_function.init_db_lambda]

    triggers = {
      rds_instance = aws_db_instance.postgres.id
    }

    provisioner "local-exec" {
        command = "aws lambda invoke --function-name init-db-lambda output.json --region ${var.aws_region}"
    }
}

resource "aws_db_parameter_group" "no_ssl" {
  name   = "no-ssl-pg"
  family = "postgres17"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

