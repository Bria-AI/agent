import os
import time
from enum import Enum
from typing import Union
from base64 import b64encode
# from tkinter import Image
# from tkinter.tix import MAIN
from PIL import Image
# import boto3
import numpy as np
import tritonclient.http as httpclient
from PIL.Image import Image as ImageType
from transformers.models.clip.feature_extraction_clip import CLIPFeatureExtractor
from transformers.models.clip.tokenization_clip import CLIPTokenizer
import gevent.ssl
from azure.ai.ml import MLClient
from azure.identity import DefaultAzureCredential



# find current file path
subscription_id = os.environ.get("azureml_subscription_id")
resource_group_name = os.environ.get("azureml_resource_group_name")
workspace_name = os.environ.get("azureml_workspace_name")
credential = DefaultAzureCredential()
# Check if given credential can get token successfully.
# access_token = credential.get_token("https://ml.azure.com/.default")
ml_client = MLClient(credential, 
                     workspace_name=workspace_name,
                     resource_group_name=resource_group_name,
                     subscription_id=subscription_id
                     )

models_base_path = os.path.dirname(os.path.realpath(__file__))
endpoint_name = os.environ.get("azureml_endpoint_name")

endpoint = ml_client.online_endpoints.get(endpoint_name)
scoring_uri = endpoint.scoring_uri

keys = ml_client.online_endpoints.get_keys(endpoint_name)
auth_key = keys.primary_key

url = scoring_uri[8:]

triton_client = httpclient.InferenceServerClient(
    url=url,
    ssl=True,
    ssl_context_factory=gevent.ssl._create_default_https_context,
)

headers = {}
headers["Authorization"] = f"Bearer {auth_key}"


class CLIPModel(Enum):
    clip_32 = "clip"
    # open_clip_14 = "open_clip_14"


class CLIPEmbedder:
    def __init__(self):
        self.clip_feature_extractor = {}
        self.tokenizer = {}
        self._load_model()

    def _load_model(self) -> None:
        """Load models into memory
        Returns:
            None
        """

        for model in [x.value for x in CLIPModel]:
            self.clip_feature_extractor[model] = CLIPFeatureExtractor.from_pretrained(
                f"{models_base_path}/{model}/feature_extractor"
            )
            self.tokenizer[model] = CLIPTokenizer.from_pretrained(
                f"{models_base_path}/{model}/tokenizer"
            )

    def run_on_image(
            self,
            image: ImageType,
            model=CLIPModel.clip_32.value,
            normalize: bool = False,
    ):
        """Run inference on a image
        Args:
            normalize:
            model:
            image (ImageType): pil image to be embedded
        Returns:
            np.array: outputs an embedding array
        """
        if len(image.mode) != 3:
            image = image.convert("RGB")
        inputs_images = self.clip_feature_extractor[model](
            images=image, return_tensors="np", padding=True
        )

        image_embeds = self.sagemaker_inference(
            [inputs_images["pixel_values"]], f"{model}_image_model"
        )

        if normalize:
            image_embeds = self.norm_embedding(image_embeds)

        return b64encode(image_embeds).decode()

    @staticmethod
    def sagemaker_inference(
            inputs, model_name, model_version="1", dtype="FP32"
    ) -> Union[np.ndarray, None]:
        inputs_ = []
        for i, image_pixels in enumerate(inputs):
            input0 = httpclient.InferInput(
                f"input__{i}", tuple(image_pixels.shape), dtype
            )
            input0.set_data_from_numpy(image_pixels)
            inputs_.append(input0)

        output_name = "output__0"
        outputs = [httpclient.InferRequestedOutput(name=output_name)]

        (
            request_body,
            header_length,
        ) = httpclient.InferenceServerClient.generate_request_body(
            inputs_, outputs=outputs
        )
        # health_ctx = triton_client.is_server_ready(headers=headers)
        # print("Is server ready - {}".format(health_ctx))

        # status_ctx = triton_client.is_model_ready(model_name, "1", headers)
        # print("Is model ready - {}".format(status_ctx))

        t = time.time()
        print(f"Sending request to {model_name}...")
        response = triton_client.infer(model_name, inputs_, outputs=outputs, headers=headers)

        print({f"{model_name}_infer": time.time() - t})
        return response.as_numpy(output_name)

    @staticmethod
    def norm_embedding(embedding):
        return embedding / embedding.norm(dim=-1, keepdim=True)


if __name__ == "__main__":
    image = Image.open(
        "/home/or/Pictures/dog.jpeg"
    )
    clip_pipeline = CLIPEmbedder()
    t = clip_pipeline.run_on_image(image)
    print(t)
