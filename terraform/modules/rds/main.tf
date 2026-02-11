resource "aws_db_instance" "postgres" {
  identifier           = "${var.project_name}-db"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro" # Free Tier eligible, compatible with arm64 processors
  allocated_storage    = 20             # Max free storage (gp2)
  storage_type         = "gp2"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password

  publicly_accessible  = false # Safer and avoids public IP charges
  skip_final_snapshot  = true  # Required to destroy without errors
  multi_az             = false # Multi-AZ is NOT free

  vpc_security_group_ids = var.vpc_security_group_ids
}