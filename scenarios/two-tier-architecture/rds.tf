resource "aws_db_parameter_group" "default" {
  name   = "rds-pg-8"
  family = "mysql8.0"
}

resource "aws_db_option_group" "default" {
  name                 = "rds-og-8"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

resource "aws_db_instance" "db1" {
  identifier = "demo-mysql"
  allocated_storage       = 10
  storage_type            = "gp2"
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0.23"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "admin123"
  parameter_group_name    = aws_db_parameter_group.default.id
  option_group_name       = aws_db_option_group.default.id
  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 1

  depends_on = [
    aws_db_parameter_group.default,
    aws_db_option_group.default
  ]
}