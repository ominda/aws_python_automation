# Load Balancer
resource "aws_lb" "r_app_lb" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.r_alb_sg.id] # Replace with your security group ID
  subnets            = [for subnet in var.public_subnets : subnet] # Replace with your subnet IDs
#   subnets = [ local.public_subnets["public_subnet-01"] ]
}

# Target Group
resource "aws_lb_target_group" "r_app_alb_tg" {
  name     = local.alb_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Listener
resource "aws_lb_listener" "r_app_alb_listener" {
  load_balancer_arn = aws_lb.r_app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.r_app_alb_tg.arn
  }
}