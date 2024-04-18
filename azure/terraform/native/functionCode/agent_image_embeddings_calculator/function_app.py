import azure.functions as func
import logging
from PIL import Image
from clip_embedder.embedder import CLIPEmbedder
from servicebus.sender import sender
import os
import io
import sentry_sdk


sentry_sdk.init(
    dsn="https://8a85874d4f547148fd2f7b7f9caf2f93@o417868.ingest.sentry.io/4505900165627904"
)
blob_path = os.environ.get("blob_path")
queue_name = os.environ.get("queue_name")
sb_ns_fqdn = os.environ.get("imageHandler__fullyQualifiedNamespace")



app = func.FunctionApp()


@app.function_name(name="imageHandler")
@app.blob_trigger(arg_name="imageBlob", path=blob_path,
                  connection="imageHandler")
def agent_image_embeddings_calculator(imageBlob: func.InputStream):
    try:
        image_bytes = imageBlob.read()
        pil_image = Image.open(io.BytesIO(image_bytes))
        clip_pipeline = CLIPEmbedder()
        img_embeddings = [clip_pipeline.run_on_image(pil_image)]

        sender(servicebus_namenpace_fqdn=sb_ns_fqdn,
            queue_name=queue_name,
            img_embeddings=img_embeddings
            )
    except Exception as e:
        sentry_sdk.capture_exception(e)
        raise
