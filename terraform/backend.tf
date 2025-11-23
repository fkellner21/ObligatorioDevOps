
terraform {
    backend "s3" {
        bucket = var.bucket_name
        key    = "ecs"
        region = var.aws_region
    }
}
