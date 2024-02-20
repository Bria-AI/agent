import os
import boto3
import io
from clip_embedder.embedder import CLIPEmbedder
from PIL import Image
import sentry_sdk
from sentry_sdk.integrations.aws_lambda import AwsLambdaIntegration
import json

sentry_sdk.init(
    dsn="https://8a85874d4f547148fd2f7b7f9caf2f93@o417868.ingest.sentry.io/4505900165627904",
    integrations=[AwsLambdaIntegration(timeout_warning=True)],
    traces_sample_rate=1.0,
)

s3 = boto3.client("s3")
sqs = boto3.client('sqs')
queue_url = os.environ.get("queue_url")

def lambda_handler(event, context):
    try:
        # Get the bucket name and file key from the event
        bucket = event["Records"][0]["s3"]["bucket"]["name"]
        key = event["Records"][0]["s3"]["object"]["key"]

        # Get image from S3
        response = s3.get_object(Bucket=bucket, Key=key)
        image_bytes = response["Body"].read()
        pil_img = Image.open(io.BytesIO(image_bytes))

        # Get inference result and save as .npy
        clip_pipeline = CLIPEmbedder()
        # return list with clip embedding on first value
        img_embeddings = [clip_pipeline.run_on_image(pil_img)]
        
        # get image uid
        # pattern = "\/(.*?)\."
        # image_uid = re.search(pattern, key).group(1)
        sqs.send_message(QueueUrl=queue_url, MessageBody=json.dumps(img_embeddings))
        print('embeddings have sent to queue')
        # Upload .json to the S3 bucket under 'embeddings/' folder
        # s3.put_object(
        #     Body=json.dumps(img_embeddings), Bucket=bucket, Key=f"embeddings/{image_uid}.json"
        # )
    except Exception as ex:
        sentry_sdk.capture_message(ex)
        raise

if __name__ == "__main__":
    event = {
  "Records": [
    {
      "eventVersion": "2.0",
      "eventSource": "aws:s3",
      "awsRegion": "us-east-1",
      "eventTime": "1970-01-01T00:00:00.000Z",
      "eventName": "ObjectCreated:Put",
      "userIdentity": {
        "principalId": "EXAMPLE"
      },
      "requestParameters": {
        "sourceIPAddress": "127.0.0.1"
      },
      "responseElements": {
        "x-amz-request-id": "EXAMPLE123456789",
        "x-amz-id-2": "EXAMPLE123/5678abcdefghijklambdaisawesome/mnopqrstuvwxyzABCDEFGH"
      },
      "s3": {
        "s3SchemaVersion": "1.0",
        "configurationId": "testConfigRule",
        "bucket": {
          "name": "aws-bria-agent-results",
          "ownerIdentity": {
            "principalId": "EXAMPLE"
          },
          "arn": "arn:aws:s3:::aws-bria-agent-results"
        },
        "object": {
          "key": "images/2359a6a4-cd96-4599-b18f-b1fd14e715e0.PNG",
          "size": 1024,
          "eTag": "0123456789abcdef0123456789abcdef",
          "sequencer": "0A1B2C3D4E5F678901"
        }
      }
    }
  ]
}
    lambda_handler(event,[])