import json
import boto3
import os
import requests
import uuid
import sentry_sdk
from sentry_sdk.integrations.aws_lambda import AwsLambdaIntegration

sentry_sdk.init(
    dsn="https://8a85874d4f547148fd2f7b7f9caf2f93@o417868.ingest.sentry.io/4505900165627904",
    integrations=[AwsLambdaIntegration(timeout_warning=True)],
    traces_sample_rate=1.0,
)

# Set up the endpoint name from environment variables
model_version = os.environ.get("model_version", "1.4")
attribution_endpoint = os.environ.get("attribution_endpoint", "https://lx5eculobj.execute-api.us-east-1.amazonaws.com/v1/bria-agent-attribution")
api_token = os.environ.get("api_token", "a10d6386dd6a11ebba800242ac130004")
queue_url = os.environ.get("queue_url")
s3 = boto3.client('s3')
sqs_client = boto3.client('sqs')


def handler(event, context):
    success_count = 0
    fail_count = 0
    batch_item_failures = []
    sqs_batch_response = {}
    for record in event['Records']:
        try:
            # Extract file_json_data from the record body
            file_json_data = json.loads(record['body'])

            # Generate a UUID for embeddings_uid
            embeddings_uid = str(uuid.uuid4())

            request_body = {
                "embeddings_base64": file_json_data,
                "embeddings_uid": embeddings_uid,
                "model_version": model_version,
                "api_token": api_token,
            }

            # Make a POST request to the API Gateway
            if attribution_endpoint:
                response = requests.post(attribution_endpoint, json=request_body)

                if json.loads(response.content).get("statusCode") != 200:
                    raise Exception(f"API request failed with status code {response.status_code}: {response.text}")
            else:
                print(f"Request body: {request_body}")
        
        except Exception as ex:
            sentry_sdk.capture_exception(ex)
            print(f"Error processing record: {ex}")
            batch_item_failures.append({"itemIdentifier": record['messageId']})
    sqs_batch_response["batchItemFailures"] = batch_item_failures
    print(f"amount of failed massages: {len(batch_item_failures)}")
    return sqs_batch_response