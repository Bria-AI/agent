import profile
import boto3
import numpy as np
import io
from clip_embedder.embedder import CLIPEmbedder
from PIL import Image
import sentry_sdk
from sentry_sdk.integrations.aws_lambda import AwsLambdaIntegration

sentry_sdk.init(
    dsn="https://8a85874d4f547148fd2f7b7f9caf2f93@o417868.ingest.sentry.io/4505900165627904",
    integrations=[AwsLambdaIntegration(timeout_warning=True)],
    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    traces_sample_rate=1.0,
    # Set profiles_sample_rate to 1.0 to profile 100%
    # of sampled transactions.
    # We recommend adjusting this value in production.
    profiles_sample_rate=1.0,
)

s3 = boto3.client("s3")


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
        img_embeddings = clip_pipeline.run_on_image(pil_img)
        npy_file = io.BytesIO()
        np.save(npy_file, img_embeddings)

        # Upload .npy to the S3 bucket under 'embeddings/' folder
        s3.put_object(
            Body=npy_file, Bucket=bucket, Key=f"embeddings/{key.split('/')[-1]}.npy"
        )
    except Exception as ex:
        sentry_sdk.capture_message(ex)
