variable "federate_identity_map" {
  type = map(object({
    name        = string
    custom_name = optional(string, "")
    audience    = list(string)
    issuer      = string
    subject     = string
  }))
  description = <<EOD
map of objects to create federate identity with their options.
```
name = (Required) Specifies the name of this Federated Identity Credential. Changing this forces a new Federated Identity Credential to be created.
custom_name = (Optional) Custom name of the federate identity
resource_group_name = (Required) Specifies the name of the Resource Group within which this Federated Identity Credential should exist. Changing this forces a new Federated Identity Credential to be created.
audience = (Required) Specifies the audience for this Federated Identity Credential. Changing this forces a new Federated Identity Credential to be created.
issuer = (Required) Specifies the issuer of this Federated Identity Credential. Changing this forces a new Federated Identity Credential to be created.
subject - (Required) Specifies the subject for this Federated Identity Credential. Changing this forces a new Federated Identity Credential to be created.
```
EOD
  default     = {}
}