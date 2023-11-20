import json
import boto3
import sagemaker
from sagemaker import Predictor, get_execution_role
import os
import base64


# Set up the endpoint name from environment variables
endpoint_name = os.environ.get("endpoint")
s3_bucket = os.environ.get("s3_bucket")
s3_path = os.environ.get("s3_path")


s3_client = boto3.client('s3')

# Get the AWS region
region = boto3.Session().region_name
role_arn = get_execution_role()


def image_decode(base64_data) -> None:
    """
    Decodes and displays an image from model output

    Args:
        model_response (dict): The response object from the model.

    Returns:
        None
    """

    return base64.b64decode(base64_data)


def handler(event, context):
    deployed_model = Predictor(endpoint_name=endpoint_name)

    try:
        if 'body' in event:
            input_data = json.loads(event['body'])
        else:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Request body missing"})
            }

        response = deployed_model.predict(
            data=json.dumps(input_data),
            initial_args={"Accept": "application/json",
                          "ContentType": "application/json"},
        ).decode("utf-8")

        response_data = json.loads(response)["artifacts"][0]

        # Save embeddings to S3
        embeddings = response_data.get('embeddings')
        if embeddings:
            s3_key = os.path.join(s3_path, 'embeddings.json')
            s3_client.put_object(Bucket=s3_bucket, Key=s3_key,
                                 Body=json.dumps(embeddings))

        return {
            "statusCode": 200,
            "image": response_data.get('image_base64')
        }

    except Exception as e:
        # Handle any exceptions that occur
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
