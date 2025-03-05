resource "aws_cloudwatch_log_group" "backend_logs" {
  name              = "/ecs/demo-app-backend"
  retention_in_days = 7
  tags = {
    Name = "demo-app-backend-logs"
  }
}

resource "aws_cloudwatch_log_group" "frontend_logs" {
  name              = "/ecs/demo-app-frontend"
  retention_in_days = 7
  tags = {
    Name = "demo-app-frontend-logs"
  }
}