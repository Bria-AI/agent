# Bria Attribution Agent
![alt text](./assets/architecture.jpeg)

BRIA's models are trained exclusively on licensed data and provided with full copyright and privacy infringement legal coverage, subject to implementation of the Attribution Agent as provided below. The Attribution Agent installed on customer side and calculates an irreversible vector. This vector is the only data passed to BRIA. BRIA cannot reproduce any image using the vector and generated images never leave customer account. BRIA receives the information from the Attribution Agent and pays the data partners on your behalf to maintain your legal coverage.

## Deploy

### Prerequisites
1. Send an email to support@bria.ai
```Plain
Title - New agent registration for <name>
Subject - Azure tenant id, <xxx>
```
2. Azure CLI - if not already exist follow the [Manual](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
3. Terraform - if not exist please follow the [Manual](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

### Terraform

1. Using Azure CLI login to your Azure tenant and switch to the destination subscription.
```
az login --tenant yourtenant.com
az account set --subscription sub_id
```
2. Navigate to `agent` repository in the terminal.
3. (Optional) Setup Terraform remote state:

By default, Terraform will use a local state file to store the Terraform state, but when working in a team with multiple people, it's recommended to setup remote state for Terraform. You can learn more about this [here](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm). We recommend that you create a file `backend.tf` in the directories listed below (`azure/terraform/native` or `azure/terraform/jumpstart`) and fill in the information according to this example:

```
terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "myaccount"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

The Storage Account `myaccount` should be a container dedicated to storing terraform remote state files.

#### Self Hosted Inference

1. Navigate to the folder `azure/terraform/native`
2. Run `terraform init`
3. Run `terraform apply`
4. Enter the `bria-api-token` when prompted (after you get back email from us)
(Optional): instead of manually provide the required parameters during the deploy, you can create a `parameters.auto.tfvars` file with the following data inside:
```
bria_spn_tenant_id                     = ""
bria_spn_client_id                     = ""
bria_spn_client_secret                 = ""
bria_model_source_storage_account_name = ""
bria_model_source_container_name       = ""
bria_api_token                         = ""
ml_vm_size                             = ""
```
5. Confirm with `yes` after reviewing the Terraform plan

#### Azure Jump Start
TBD
## Testing
TBD
## FAQ
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
