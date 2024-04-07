import azure.functions as func
import logging
from PIL import Image
import os
import io
import json

blob_path = os.environ.get("blob_path")
queue_name = os.environ.get("queue_name")




app = func.FunctionApp()

@app.function_name(name="blobTrigger")
@app.blob_trigger(arg_name="imageBlob", path=blob_path,
                               connection="imageHandler")
@app.service_bus_queue_output(arg_name="message",connection="imageHandler",queue_name=queue_name)

def agent_image_embeddings_calculator(imageBlob: func.InputStream, message: func.Out[str]):
    image_bytes = imageBlob.read()
    pil_image = Image.open(io.BytesIO(image_bytes))
    logging.info(
        f"{pil_image}"
    )
    message_input = f"blobName is {imageBlob.name}"
    message.set(message_input)