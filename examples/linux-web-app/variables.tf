variable "azure_region" {
  description = "Azure region to use."
  type        = string
}



variable "certificate_keyvault_id" {
  description = "ID of the certificate stored in a KeyVault"
  type        = string
}

variable "certificate_id" {
  description = "ID of an existant certificate"
  type        = string
}
