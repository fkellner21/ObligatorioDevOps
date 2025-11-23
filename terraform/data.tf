data "aws_iam_role" "lab_role" {
    name = "LabRole"
}

data "aws_availability_zones" "available" {
    state = "available"
}
