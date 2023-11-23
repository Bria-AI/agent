# Bria Attribution Agent
![alt text](./assets/architecture.jpeg)

Bria attribution agent supports the data partner's revenue share model as part of Bria.ai Generative platform.
To utilize Bria foundation models, it is necessary to collect all generations made by them. When running on the Bria inference service, this logic is taken care of for you. However, if the inference is managed by a third party outside of Bria, you will need to install this Agent. For that, we provide the infrastructure as code for cloud deployment.

# Deploy

### Self Hosted Inference
WIP...

### AWS Jump Start
1. Send an email to support@bria.ai
```Plain
Title - New agent registration for <name>
Subject - AWS account id, <xxx>
```
2. Deploy one of our [models](https://aws.amazon.com/marketplace/seller-profile?id=seller-ilfk2fw5juhfi) on as sagemaker endpoint
5. After you get back email from us, fill in the config file:
```YML
SG_ENDPOINT_ARN="..."
...
```
4. Run "agent/aws_jumpstart/run.sh", this will trigger another cloudformation to install the agent
```YML
# Make sure the user running the script have at least the following policy
...
```
5. You now have a lambda deployed on your account and you can start sending requests, for example:
```python
import boto3

# Set up the AWS Lambda client
lambda_client = boto3.client('lambda', region_name='your_region')

# Specify the Lambda function name
function_name = 'your_lambda_function_name'

# Input payload for the Lambda function (if needed)
payload = {
    "prompt": "A towering redwood tree in a forest, during twilight",
    "width": 512,
    "height": 512,
    "steps": 50,
    "seed": 42,
    "negative_prompt": "blue sky, people",
}

# Make the request to the Lambda function
response = lambda_client.invoke(
    FunctionName=function_name,
    InvocationType='RequestResponse',
    Payload=json.dumps(payload),
)

response_payload = json.load(response['Payload'])
print(response_payload)
```

# FAQ
### Do I have to install the Attribution Agent?
Yes,  BRIA  offers  diffuse  models  suitable  for  commercial  use,  that  are  trained  solely  on  licensed  data.  The 
Attribution Agent enables BRIA to comply with its payment obligation to its data partner, such that your use of 
the models will be fully legally covered. 

### Do I need to pay to date partners to retain the legal coverage?
No, BRIA receives the information from the Attribution Agent and pays the attribution payments to its data 
partners on our behalf, such that you retain full legal coverage. 

### Does BRIA have access to the generated images?
No, generated images never leave your account. The Attribution Agent is installed on the customer side and 
turns any generated image into an irreversible vector. This irreversible vector is the only information being 
passed to BRIA. BRIA cannot reproduce any image using the irreversible vector. This information is required 
solely to meet the payment obligations to data partners. 

### Is there any performance impact caused by the Attribution Agent?
No, the Attribution Agent operates offline such that real-time inference and generation are not impacted at all.

### Can the Attribution Agent erase or modify my image generations?
No, the Attribution Agent extracts the irreversible vector from a copy of the generated image on the customer 
side. Once extracted, such copy is permanently deleted to avoid any cost or privacy concerns.
