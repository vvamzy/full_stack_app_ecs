# Create ECR Repositories
resource "aws_ecr_repository" "backend" {
  name = "demo-app-backend"
  force_delete = true
  tags = {
    Name = "demo-app-backend"
  }
}

resource "aws_ecr_repository" "frontend" {
  name = "demo-app-frontend"
  force_delete = true
  tags = {
    Name = "demo-app-frontend"
  }
}