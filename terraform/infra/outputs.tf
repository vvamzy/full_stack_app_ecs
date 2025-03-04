output "ecs_cluster_name" {
  value = aws_ecs_cluster.demo_cluster.name
}

output "rds_endpoint" {
  value = aws_db_instance.demo_rds.endpoint
}

output "ecr_backend_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_frontend_repository_url" {
  value = aws_ecr_repository.frontend.repository_url
}