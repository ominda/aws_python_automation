# Create a launch template
resource "aws_launch_template" "r_app_launch_template" {
  name = local.launch_template_name

  # AMI and instance type for the EC2 instances
  image_id      = data.aws_ami.d_ubuntu_amis.id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.r_asg_iam_instance_profile.name
  } 
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [ aws_security_group.r_launch_template_sg.id ]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.asg_instance_name
    }
  }
  
  # instance_initiated_shutdown_behavior = terminate

  # User data to install your application
  user_data = base64encode(file("${path.module}/scripts/startup_script.sh"))
}

# Create auto scaling group
resource "aws_autoscaling_group" "r_autoscaling_group" {
  desired_capacity = 1
  max_size         = 3
  min_size         = 1
  launch_template {
    id      = aws_launch_template.r_app_launch_template.id
    version = "$Latest"
  }

  # Target the VPC subnets where your instances will be launched
  # vpc_zone_identifier = [local.public_subnets["public_subnet-01"]]
  vpc_zone_identifier = [ for subnet in var.public_subnets : subnet ]

  # Health check
  health_check_type         = "ELB"
  health_check_grace_period = 180

  target_group_arns = [aws_lb_target_group.r_app_alb_tg.arn]
}

# Create ASG policy
resource "aws_autoscaling_policy" "r_asg_scale_out_policy" {
  name                   = local.asg_scale_out_policy_name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 180
  autoscaling_group_name = aws_autoscaling_group.r_autoscaling_group.name
}

resource "aws_autoscaling_policy" "r_asg_scale_in_policy" {
  name                   = local.asg_scale_in_policy_name
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 180
  autoscaling_group_name = aws_autoscaling_group.r_autoscaling_group.name
}
