data "aws_secretsmanager_secret_version" "demo-passwd" {
  secret_id = "demo-passwd"
}

resource "aws_db_instance" "rds_db" {
  identifier              = "rdsdemo"
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  db_name                 = "demords"
  backup_retention_period = 0
  apply_immediately       = true
  deletion_protection     = false
  parameter_group_name    = "default.mysql5.7"
  skip_final_snapshot     = true
  publicly_accessible     = true
  username                = "admin"
  password                = var.rds_passwd
  tags = {
    Name = "rds-demo"
  }
}

output "password-value" {
  value       = data.aws_secretsmanager_secret_version.demo-passwd.secret_string
  description = "rds secret manager stored passwd"
  sensitive   = true
}