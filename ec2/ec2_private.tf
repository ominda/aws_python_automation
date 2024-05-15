# # Construct local variables
# locals {
#   private_subnets = var.private_subnets
# }

# # Worker Nodes
# resource "aws_instance" "r_worker_nodes" {
#     count = var.worker_node_count
#   ami           = data.aws_ami.d_ubuntu_amis.id
#   instance_type = "t3.micro"
#   associate_public_ip_address = false
#   key_name = var.ssh_key  
#   subnet_id = local.private_subnets[0].id
#   vpc_security_group_ids = [aws_security_group.r_worker_node_sg.id]
#   user_data_base64 = base64encode(file("${path.module}/scripts/install_kubuernetes.sh"))
#   user_data_replace_on_change = true
  

#   tags = {
#     Name = format("${local.base_name}-worker_node-0%d", count.index + 1)
#   }
# }

# # Master Nodes
# resource "aws_instance" "r_master_nodes" {
#   count = var.master_node_count
#   ami           = data.aws_ami.d_ubuntu_amis.id
#   instance_type = "t3.micro"
#   associate_public_ip_address = false
#   key_name = var.ssh_key  
#   subnet_id = local.private_subnets[1].id
#   vpc_security_group_ids = [aws_security_group.r_master_node_sg.id]
#   user_data_base64 = base64encode(file("${path.module}/scripts/install_kubuernetes.sh"))
#   user_data_replace_on_change = true
  
#   tags = {
#     Name = format("${local.base_name}-master_node-0%d", count.index + 1)
#   }
# }

# # Worker nodes Security group
# resource "aws_security_group" "r_worker_node_sg" {
#   name        = "Worker_Nodes-SG"
#   description = "Allow all access from the master nodes security group"
#   vpc_id      = var.vpc_id

#   ingress  {
#     from_port = 443
#     to_port = 443
#     protocol = "TCP"
#     security_groups = [aws_security_group.r_public_default_sg.id]
#   }

#     ingress  {
#     from_port = 22
#     to_port = 22
#     protocol = "TCP"
#     security_groups = [aws_security_group.r_public_default_sg.id]
#   }

#   # Kubelet API access
#   ingress  {
#     from_port        = 10250
#     to_port          = 10250
#     protocol         = "TCP"
#     security_groups      = [aws_security_group.r_master_node_sg.id]
#   }


#   # NodePorts
#   ingress  {
#     from_port        = 30000
#     to_port          = 32767
#     protocol         = "TCP"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Worker_Nodes-SG"
#   }
# }
# # Master node Security group

# # Security group for allowing public default ports
# resource "aws_security_group" "r_master_node_sg" {
#   name        = "Control_Plane-SG"
#   description = "Allow access to the Control plane instance"
#   vpc_id      = var.vpc_id

#   ingress  {
#     from_port = 443
#     to_port = 443
#     protocol = "TCP"
#     security_groups = [aws_security_group.r_public_default_sg.id]
#   }

#     ingress  {
#     from_port = 22
#     to_port = 22
#     protocol = "TCP"
#     security_groups = [aws_security_group.r_public_default_sg.id]
#   }

#   ingress  {
#     from_port = 6443
#     to_port = 6443
#     protocol = "TCP"
#     cidr_blocks = [local.private_subnets[0].cidr_block]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Control_Plane-SG"
#   }
# }