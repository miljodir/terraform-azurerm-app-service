locals {
  unique_prefix = var.use_caf_naming ? compact(["${var.workload}${var.unique}", local.name_suffix]) : compact([var.workload, local.name_suffix])
}

data "azurecaf_name" "application_insights" {
  #name          = local.name_suffix
  resource_type = "azurerm_application_insights"
  prefixes      = compact([var.workload, local.name_suffix])
  suffixes      = compact([var.use_caf_naming ? "" : "ai"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "app_service_web" {
  resource_type = "azurerm_app_service"
  prefixes      = local.unique_prefix
  suffixes      = compact([var.use_caf_naming ? "" : "web"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}
