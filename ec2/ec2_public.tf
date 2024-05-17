# Create EC2 instance
resource "aws_instance" "r_public_ec2_instances" {
  ami           = data.aws_ami.d_ubuntu_amis.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name = var.ssh_key  
  subnet_id = local.public_subnets["public_subnet-01"]
  vpc_security_group_ids = [aws_security_group.r_public_default_sg.id]
  iam_instance_profile = aws_iam_instance_profile.r_iam_instance_profile.name
  user_data_base64 = base64encode(file("${path.module}/scripts/startup_script.sh"))
  user_data_replace_on_change = true

  tags = {
    Name = "${local.base_name}-Bastionhost-01"
  }
}

# Security group for allowing public default ports
resource "aws_security_group" "r_public_default_sg" {
  name        = "${local.base_name}-BastionHost-SG"
  description = "Allow SSH and https trafic to the hosts"
  vpc_id      = var.vpc_id

  ingress  {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.base_name}-Default_public-SG"
  }
}

