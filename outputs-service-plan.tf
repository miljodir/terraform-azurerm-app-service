output "module_service_plan" {
  description = "Service Plan output object. Please refer to [module documentation](https://github.com/claranet/terraform-azurerm-app-service-plan/blob/master/README.md#outputs)."
  value       = one(module.service_plan[*])
}
