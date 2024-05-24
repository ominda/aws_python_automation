# aws_python_automation

# vpc module is the only common module. You can't use other modules simultaniously.
## As Example
    vpc + ec2
    or
    vpc + autoscaler

# vpc module
VPC module contains a VPC, Two public subnets, IGW, Route table
Basic infrastructure for deploy EC2 and other cloud resources.

# ec2 module
Automate EC2 provisioning depends on the CPU utilization of the existing instance.
Using Lamba, Cloudwatch and Python.

# autoscaler module
Automatically scale (out or in) depends on EC2 instance CPU utilization.
Using ASG, ASG policy, Cloudwatch alarm, Launch Template
