resource "aws_ecs_cluster" "main" {
    name = var.ecs_cluster_name

    tags = {
        Name = var.ecs_cluster_name
    }
}
