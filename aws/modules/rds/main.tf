resource "aws_db_subnet_group" "dev_postgresql_subnet_group" {
  name       = "dev-postgresql-subnet-group"
  subnet_ids = [var.dev_private_subnet_1_id, var.dev_private_subnet_2_id]

  tags = {
    Name = "Database Subnet Group for Dev PostgreSQL"
  }
}

resource "aws_db_subnet_group" "test_postgresql_subnet_group" {
  name       = "test-postgresql-subnet-group"
  subnet_ids = [var.test_private_subnet_1_id, var.test_private_subnet_2_id]

  tags = {
    Name = "Database Subnet Group for Test PostgreSQL"
  }
}

resource "aws_db_subnet_group" "prod_postgresql_subnet_group" {
  name       = "prod-postgresql-subnet-group"
  subnet_ids = [var.prod_private_subnet_1_id, var.prod_private_subnet_2_id]

  tags = {
    Name = "Database Subnet Group for Prod PostgreSQL"
  }
}

resource "aws_db_parameter_group" "dev_postgres_group" {
  name        = "dev-postgres-group"
  family      = "postgres11"
  description = "Custom PostgreSQL Parameter Group"
}

resource "aws_db_parameter_group" "test_postgres_group" {
  name        = "test-postgres-group"
  family      = "postgres11"
  description = "Custom PostgreSQL Parameter Group"
}

resource "aws_db_parameter_group" "prod_postgres_group" {
  name        = "prod-postgres-group"
  family      = "postgres11"
  description = "Custom PostgreSQL Parameter Group"
}

resource "aws_db_instance" "dev_postgresql_instance" {
  depends_on = [aws_db_subnet_group.dev_postgresql_subnet_group]
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.18"
  instance_class         = "db.t3.micro"
  identifier             = "dev"
  db_name                = "dev"
  username               = "pgadmin"
  password               = "Duy8WrE6!9bTk"
  parameter_group_name   = aws_db_parameter_group.dev_postgres_group.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.sg_private_id]
  db_subnet_group_name   = aws_db_subnet_group.dev_postgresql_subnet_group.name
  multi_az               = false
}

resource "aws_db_instance" "test_postgresql_instance" {
  depends_on = [aws_db_subnet_group.test_postgresql_subnet_group]
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.18"
  instance_class         = "db.t3.micro"
  identifier             = "test"
  db_name                = "test"
  username               = "pgadmin"
  password               = "Duy8WrE6!9bTk"
  parameter_group_name   = aws_db_parameter_group.test_postgres_group.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.sg_private_id]
  db_subnet_group_name   = aws_db_subnet_group.test_postgresql_subnet_group.name
  multi_az               = false
}

resource "aws_db_instance" "prod_postgresql_instance" {
  depends_on = [aws_db_subnet_group.prod_postgresql_subnet_group]
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "11.18"
  instance_class         = "db.t3.micro"
  identifier             = "prod"
  db_name                = "prod"
  username               = "pgadmin"
  password               = "Duy8WrE6!9bTk"
  parameter_group_name   = aws_db_parameter_group.prod_postgres_group.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.sg_private_id]
  db_subnet_group_name   = aws_db_subnet_group.prod_postgresql_subnet_group.name
  multi_az               = false
}