# Bria Attribution Agent
Bria attribution engine supports the data partner's revenue share model as part of Bria.ai Generative platform.
To utilize Bria foundation models, it is necessary to collect all generations made by them. When running on the Bria inference service, this logic is taken care of for you. However, if the inference is managed by a third party outside of Bria, you will need to install this Agent. For that, we provide the infrastructure as code for cloud deployment.

# Overview

### Self Hosted Inferance
...

### AWS Jump Start getting started
Deploy Bria model through AWS marketplace (Jumpstart) is possible in 2 ways:

1. Integrate directly from AWS marketplace, this will create an endpoint  to use but all generations will not be fully commercial use due to the fact that attribution metadata (embedding) was not shared with Bria 
2. Deploy with Bria cloud formation stack - Here you will get a similar stack to the standard agent above, the only difference will be that jump-start inference endpoint will be used VS none managed inference service

After deployed clients can send requests to a single endpoint and utilize Bria model


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
