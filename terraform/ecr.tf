resource "aws_ecr_repository" "api_gateway" {
    name                 = var.ecr_repository_name_api_gateway
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }

    force_delete = true

    tags = {
        Name = var.ecr_repository_name_api_gateway
    }
}

resource "aws_ecr_repository" "product_service" {
    name                 = var.ecr_repository_name_product_service
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }

    force_delete = true

    tags = {
        Name = var.ecr_repository_name_product_service
    }
}

resource "aws_ecr_repository" "inventory_service" {
    name                 = var.ecr_repository_name_inventory_service
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }

    force_delete = true

    tags = {
        Name = var.ecr_repository_name_inventory_service
    }
}
