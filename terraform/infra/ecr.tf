# Create ECR Repositories
resource "aws_ecr_repository" "backend" {
  name = "demo-app-backend"
  tags = {
    Name = "demo-app-backend"
  }
}

resource "aws_ecr_repository" "frontend" {
  name = "demo-app-frontend"
  tags = {
    Name = "demo-app-frontend"
  }
}