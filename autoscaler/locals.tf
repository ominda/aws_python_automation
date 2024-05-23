# Construct local variables
locals {
  base_name                 = "${var.project}_${var.env}"
  public_subnets            = var.public_subnets
  launch_template_name      = "${local.base_name}-launch_template"
  asg_sg_name               = "${local.base_name}-asg-SG"
  cw_high_cpu_alarm_name    = "${local.base_name}-HighCPUUtilization"
  cw_low_cpu_alarm_name     = "${local.base_name}-LowCPUUtilization"
  asg_scale_out_policy_name = "${local.base_name}-scale-out"
  asg_scale_in_policy_name  = "${local.base_name}-scale-in"
  asg_instance_role_name = "${local.base_name}-asg-instanceProfileRole"
  asg_instance_profile_name = "${local.base_name}-asg-SSM-instance-profile"
  asg_instance_name = "${local.base_name}-ec2"
}