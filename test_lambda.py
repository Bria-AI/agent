import boto3
import requests
from requests_aws4auth import AWS4Auth

region = 'us-east-1' # your region name
service = 'execute-api' 
session = boto3.Session()
credentials = session.get_credentials()
aws_access_key_id = credentials.access_key
aws_secret_access_key = credentials.secret_key
aws_session_token = credentials.token  # This can be None if not using temporary credentials

# Create the AWS Auth object
awsauth = AWS4Auth(aws_access_key_id, aws_secret_access_key, region, service, session_token=aws_session_token)

# specify api gateway url
host = 'mt35xsct6a.execute-api.us-east-1.amazonaws.com'
endpoint = f"https://{host}/PROD/jumpstart-agent"

# Input payload for the Lambda function (if needed)
payload = {
            "prompt": "A towering redwood tree in a forest, during twilight",
            "width": 512,
            "height": 512,
            "steps": 50,
            "seed": 42,
            "negative_prompt": "blue sky, people"
}

# Make the request to the Lambda function
response = requests.post(endpoint, auth=awsauth, json=payload)
response_data = response.json()
