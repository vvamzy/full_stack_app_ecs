# Create ALB
resource "aws_lb" "demo_alb" {
  name               = "demo-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "demo-app-alb"
  }
}

# Create Target Group
resource "aws_lb_target_group" "demo_tg" {
  name     = "demo-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo_vpc.id
  target_type = "ip" # Set target type to IP for awsvpc mode

  health_check {
    path = "/"
  }

  tags = {
    Name = "demo-app-tg"
  }
}
# Create ALB Listener
resource "aws_lb_listener" "demo_listener" {
  load_balancer_arn = aws_lb.demo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo_tg.arn
  }

  tags = {
    Name = "demo-app-listener"
  }

  # Ensure the listener is deleted before the target group
  depends_on = [aws_lb_target_group.demo_tg]
}