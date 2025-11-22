resource "aws_elasticache_subnet_group" "redis" {
    name       = "redis-subnet-group"
    subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_elasticache_cluster" "redis" {
    cluster_id           = "redis-cluster"
    engine               = "redis"
    node_type            = "cache.t2.micro"
    num_cache_nodes      = 1
    port                 = 6379
    subnet_group_name    = aws_elasticache_subnet_group.redis.name

    security_group_ids = [aws_security_group.redis.id]
}
