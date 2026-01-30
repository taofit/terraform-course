resource "aws_db_instance" "db_instance" {
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "15"
  instance_class      = "db.t4g.micro"
  name                = var.db_name
  username            = var.db_user
  password            = var.db_pass
  skip_final_snapshot = true
}
