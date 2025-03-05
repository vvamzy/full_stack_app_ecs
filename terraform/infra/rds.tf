data "aws_secretsmanager_secret" "rds_credentials" {
  name = "app-rds-credentials"
}

data "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = data.aws_secretsmanager_secret.rds_credentials.id
}

locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials.secret_string)
}

# Create RDS Instance
resource "aws_db_instance" "demo_rds" {
  identifier             = "demo-app-rds"
  engine                 = "mysql"
  engine_version         = "8.0.40"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = local.rds_credentials.username
  password               = local.rds_credentials.password
  db_subnet_group_name   = aws_db_subnet_group.demo_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = true
  tags = {
    Name = "demo-app-rds"
  }
}

# Create DB Subnet Group
resource "aws_db_subnet_group" "demo_db_subnet_group" {
  name       = "demo-app-db-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  tags = {
    Name = "demo-app-db-subnet-group"
  }
}
