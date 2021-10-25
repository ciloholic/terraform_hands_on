resource "aws_rds_cluster_parameter_group" "example" {
  name   = "${local.service_config.prefix}-cluster-parameter-group"
  family = local.aurora_config.family

  dynamic "parameter" {
    for_each = [
      { name = "character_set_client", value = "utf8mb4" },
      { name = "character_set_connection", value = "utf8mb4" },
      { name = "character_set_database", value = "utf8mb4" },
      { name = "character_set_filesystem", value = "utf8mb4" },
      { name = "character_set_results", value = "utf8mb4" },
      { name = "character_set_server", value = "utf8mb4" },
      { name = "collation_connection", value = "utf8mb4_general_ci" },
      { name = "collation_server", value = "utf8mb4_general_ci" },
      { name = "time_zone", value = "Asia/Tokyo" }
    ]
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_db_parameter_group" "example" {
  name   = "${local.service_config.prefix}-db-parameter-group"
  family = local.aurora_config.family
}

resource "aws_db_subnet_group" "example" {
  name = "${local.service_config.prefix}-db-subnet-group"
  subnet_ids = [
    for az in local.network_config.availability_zones :
    aws_subnet.private_subnet_storage[az].id
  ]
}

resource "aws_rds_cluster" "example" {
  cluster_identifier              = local.service_config.prefix
  master_username                 = local.aurora_config.master_username
  master_password                 = random_password.aurora_master_password.result
  engine                          = local.aurora_config.engine
  engine_version                  = local.aurora_config.engine_version
  port                            = 5432
  vpc_security_group_ids          = [aws_security_group.aurora.id]
  db_subnet_group_name            = aws_db_subnet_group.example.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.name
  storage_encrypted               = true
  skip_final_snapshot             = true
  database_name                   = local.service_config.name

  lifecycle {
    ignore_changes = [master_password]
  }

  tags = {
    Name = "${local.service_config.prefix}-aurora-cluster"
  }
}

resource "aws_rds_cluster_instance" "example" {
  count                      = local.aurora_config.cluster_instance_count
  cluster_identifier         = aws_rds_cluster.example.id
  identifier                 = "${local.service_config.prefix}-${count.index}"
  engine                     = local.aurora_config.engine
  engine_version             = local.aurora_config.engine_version
  instance_class             = local.aurora_config.instance_class
  db_parameter_group_name    = aws_db_parameter_group.example.name
  db_subnet_group_name       = aws_db_subnet_group.example.name
  ca_cert_identifier         = local.aurora_config.ca_cert_identifier
  auto_minor_version_upgrade = false

  tags = {
    Name = "${local.service_config.prefix}-aurora-cluster-instance"
  }
}
