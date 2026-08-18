variable "app_service_pe_subnet_id" {
  description = "ID of the subnet used by the App Service private endpoint."
  type        = string
  default     = null
}

variable "privatedns_resource_group_name" {
  description = "Name of the resource group that owns the centralized private DNS zone. Retained for compatibility; private DNS zone groups are managed centrally."
  type        = string
  default     = "p-dns-pri"
}
