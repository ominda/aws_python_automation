import boto3
import os

# Initialize boto3 clients
ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    # Extract information from CloudWatch event
    alarm_name = event['alarmData']['alarmName']
    new_state = event['alarmData']['state']['value']
    
    print(">>> ", alarm_name)
    print(">>> ", new_state)
	
    # Variables - replace these with your specific values or retrieve them from environment variables
    wc_alarm_name = "C-OPS-Poc_Dev-ec2_cpu_utilization_alarm"
    ami_id = os.environ['AMI_ID']  # AMI ID for the EC2 instance
    instance_type = os.environ['INSTANCE_TYPE']  # EC2 instance type
    key_name = os.environ['KEY_NAME']  # Key pair name for SSH access
    security_group_id = os.environ['SECURITY_GROUP_ID']  # Security group ID
    subnet_id = os.environ['SUBNET_ID']  # Subnet ID in the VPC

    # Create the EC2 instance
    if alarm_name == wc_alarm_name and new_state == "ALARM":
        try:
            response = ec2.run_instances(
                ImageId=ami_id,
                InstanceType=instance_type,
                KeyName=key_name,
                SecurityGroupIds=[security_group_id],
                SubnetId=subnet_id,
                MinCount=1,
                MaxCount=1
            )

            # Get the instance ID of the created instance
            instance_id = response['Instances'][0]['InstanceId']

            print(f"Successfully launched EC2 instance {instance_id}")

        except Exception as e:
            print(f"Error launching EC2 instance: {str(e)}")

# Example event to trigger the function
if __name__ == "__main__":
    lambda_handler({}, {})
