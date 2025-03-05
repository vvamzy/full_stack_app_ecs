

# Create Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "demo-app-rds-sg"
  description = "Allow inbound traffic to RDS"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-app-rds-sg"
  }
}


# Create Security Group for ECS
resource "aws_security_group" "ecs_sg" {
  name        = "demo-app-ecs-sg"
  description = "Allow inbound traffic to ECS and outbound to RDS"
  vpc_id      = aws_vpc.demo_vpc.id

  # Allow inbound HTTP traffic (for frontend & backend)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow backend API calls (if needed on a different port)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound connections to RDS
  egress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.rds_sg.id]  # Allow traffic to RDS
  }

  # Allow all outbound traffic (for external APIs, logging, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-app-ecs-sg"
  }
}

