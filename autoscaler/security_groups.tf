# Security group for allowing public default ports
resource "aws_security_group" "r_launch_template_sg" {
  name        = local.asg_sg_name
  description = "Allow HTTP and https trafic to the hosts"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [ aws_security_group.r_alb_sg.id ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [ aws_security_group.r_alb_sg.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.asg_sg_name
  }
}

# Security group for ELB
resource "aws_security_group" "r_alb_sg" {
  name        = local.alb_sg_name
  description = "Allow HTTP and https trafic to the hosts"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.alb_sg_name
  }
}
