import json
import boto3

def lambda_handler(event, context):
    print(event)
    # # Extract information from CloudWatch event
    # alarm_name = event['AlarmName']
    # new_state = event['NewStateReason']

    # # Get EC2 client
    # ec2_client = boto3.client('ec2')

    # # Check if alarm is in ALARM state due to high CPU
    # if alarm_name == "WebServerHighCPU" and new_state == "ALARM":
    #     # Launch a new EC2 instance with your web server image
    #     # (Replace with your specific launch configuration details)
    #     launch_response = ec2_client.run_instances(
    #         ImageId="ami-XXXXXXXX",
    #         InstanceType="t2.micro",
    #         MinCount=1,
    #         MaxCount=1
    #     )
        
    # # You can add logic here to terminate an instance if CPU is low
    # # based on a separate CloudWatch alarm
    
    return {
        'statusCode': 200,
        # 'body': json.dumps('Scaling action triggered by ' + alarm_name)
        'body': json.dumps('Scaling action triggered by ')
    }