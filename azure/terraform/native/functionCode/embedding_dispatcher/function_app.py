import json
import os
import requests
import uuid
import sentry_sdk
import azure.functions as func
import logging




sentry_sdk.init(
    dsn="https://8a85874d4f547148fd2f7b7f9caf2f93@o417868.ingest.sentry.io/4505900165627904"
)
# Set up the endpoint name from environment variables
model_version = os.environ.get("model_version", "2.3")
attribution_endpoint = os.environ.get("attribution_endpoint", "https://lx5eculobj.execute-api.us-east-1.amazonaws.com/v1/bria-agent-attribution")
api_token = os.environ.get("api_token")
queue_name = os.environ.get("queue_name")

app = func.FunctionApp()

@app.function_name(name="embedding_dispatcher")
@app.service_bus_queue_trigger(arg_name="message", queue_name=queue_name,
                               connection="embeddingsDispacher") 
def embedding_dispatcher(message: func.ServiceBusMessage):
    try:
        file_json_data = json.loads(message.get_body().decode('utf-8'))
        embeddings_uid = str(uuid.uuid4())
        request_body = {
            "embeddings_base64": file_json_data,
            "embeddings_uid": embeddings_uid,
            "model_version": model_version,
            "api_token": api_token,
        }

        if attribution_endpoint:
            response = requests.post(attribution_endpoint, json=request_body)   
            if json.loads(response.content).get("statusCode") != 200:
                raise Exception(f"API request failed with status code {response.status_code}: {response.text}")
            else:
                print(f"Request body: {request_body}")
    except Exception as ex:
        sentry_sdk.capture_exception(ex)
        logging.info(f"Error processing record: {ex}")
        raise