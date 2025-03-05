# Create ECS Cluster
resource "aws_ecs_cluster" "demo_cluster" {
  name = "demo-app-cluster"
  tags = {
    Name = "demo-app-cluster"
  }
}

resource "aws_ecs_task_definition" "demo_task" {
  family                   = "demo-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "058264481630.dkr.ecr.ap-south-1.amazonaws.com/demo-app-backend:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.demo_rds.endpoint
        },
        {
          name  = "DB_USER"
          value = "vamsi"
        },
        {
          name  = "DB_PASSWORD"
          value = local.rds_credentials.password
        },
        {
          name  = "DB_NAME"
          value = "mydb"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/demo-app-backend"
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name      = "frontend"
      image     = "058264481630.dkr.ecr.ap-south-1.amazonaws.com/demo-app-frontend:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80 # Frontend uses host port 8080
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/demo-app-frontend"
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "demo-app-task"
  }
}
# Create ECS Service
resource "aws_ecs_service" "demo_service" {
  name            = "demo-app-service"
  cluster         = aws_ecs_cluster.demo_cluster.id
  task_definition = aws_ecs_task_definition.demo_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true # Assign public IP to tasks
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.demo_tg.arn
    container_name   = "frontend"
    container_port   = 8080 # Updated to match the frontend container port
  }

  tags = {
    Name = "demo-app-service"
  }
}
# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "demo-app-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "demo-app-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}