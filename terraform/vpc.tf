resource "aws_vpc" "main" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "ecs-vpc"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "ecs-igw"
    }
}

resource "aws_subnet" "public_1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "ecs-public-subnet-1"
    }
}

resource "aws_subnet" "public_2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = true

    tags = {
        Name = "ecs-public-subnet-2"
    }
}

resource "aws_subnet" "private_1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.3.0/24"
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false

    tags = { Name = "ecs-private-subnet-1" }
}

resource "aws_subnet" "private_2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.4.0/24"
    availability_zone       = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = false

    tags = { Name = "ecs-private-subnet-2" }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "ecs-public-rt"
    }
}

resource "aws_route_table_association" "public_1" {
    subnet_id      = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
    subnet_id      = aws_subnet.public_2.id
    route_table_id = aws_route_table.public.id
}

# Elastic IP para NAT Gateway
resource "aws_eip" "nat" {
    domain = "vpc"
    
    tags = {
        Name = "ecs-nat-eip"
    }
    
    depends_on = [aws_internet_gateway.main]
}

# NAT Gateway en subnet pública
resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public_1.id
    
    tags = {
        Name = "ecs-nat-gateway"
    }
    
    depends_on = [aws_internet_gateway.main]
}

# Route table para subnets privadas
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
    }
    
    tags = {
        Name = "ecs-private-rt"
    }
}

# Asociar route table a subnets privadas
resource "aws_route_table_association" "private_1" {
    subnet_id      = aws_subnet.private_1.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
    subnet_id      = aws_subnet.private_2.id
    route_table_id = aws_route_table.private.id
}