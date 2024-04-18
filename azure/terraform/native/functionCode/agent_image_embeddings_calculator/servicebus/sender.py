import json
from azure.identity import DefaultAzureCredential
from azure.servicebus import ServiceBusClient, ServiceBusMessage


def sender(servicebus_namenpace_fqdn: str,queue_name: str ,img_embeddings: list[str]):
    credential = DefaultAzureCredential()

    servicebus_client = ServiceBusClient(servicebus_namenpace_fqdn, credential)
    sender = servicebus_client.get_queue_sender(queue_name)
    
    message = ServiceBusMessage(body=json.dumps(img_embeddings), content_type="application/json")

# Send the message
    sender.send_messages(message)