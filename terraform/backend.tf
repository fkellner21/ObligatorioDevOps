
terraform {
    backend "s3" {
        bucket = "obl-s3v2"
        key    = "ecs"
        region = "us-east-1"
    }
}
