locals {
  public_network_access_enabled = split("-", var.workload)[0] == "d" ? true : var.public_network_access_enabled ? true : false
  scm_authorized_ips = [for ip in(local.public_network_access_enabled ? try(concat(values(module.network_vars[0].known_public_ips), var.scm_authorized_ips), (values(module.network_vars[0].known_public_ips))) : []) :
    can(regex(".*\\/\\d+$", ip)) ? ip : format("%s/32", ip)
  ]
  authorized_ips = [for ip in(local.public_network_access_enabled ? try(concat(values(module.network_vars[0].known_public_ips), var.authorized_ips), (values(module.network_vars[0].known_public_ips))) : []) :
    can(regex(".*\\/\\d+$", ip)) ? ip : format("%s/32", ip)
  ]
}
module "network_vars" {
  # private module used for public IP whitelisting
  count  = local.public_network_access_enabled == true ? 1 : 0
  source = "git@github.com:miljodir/cp-shared.git//modules/public_nw_ips?ref=public_nw_ips/v1"
}

module "linux_web_app" {
  for_each = toset(lower(var.os_type) == "linux" ? ["enabled"] : [])

  source = "./modules/linux-web-app"

  providers = {
    azurerm = azurerm
  }

  workload            = var.workload
  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name
  unique              = var.unique

  use_caf_naming                  = var.use_caf_naming
  name_prefix                     = var.name_prefix
  name_suffix                     = var.name_suffix
  app_service_custom_name         = var.app_service_custom_name
  custom_diagnostic_settings_name = var.custom_diagnostic_settings_name

  service_plan_id                = local.service_plan_id
  web_app_key_vault_id           = var.web_app_key_vault_id
  skip_identity_role_assignments = var.skip_identity_role_assignments

  app_settings       = var.app_settings
  site_config        = var.site_config
  auth_settings      = var.auth_settings
  auth_settings_v2   = var.auth_settings_v2
  connection_strings = var.connection_strings
  sticky_settings    = var.sticky_settings

  mount_points               = var.mount_points
  client_affinity_enabled    = var.client_affinity_enabled
  https_only                 = var.https_only
  client_certificate_enabled = var.client_certificate_enabled

  staging_slot_enabled             = var.staging_slot_enabled
  staging_slot_custom_name         = var.staging_slot_custom_name
  staging_slot_custom_app_settings = var.staging_slot_custom_app_settings

  custom_domains                = var.custom_domains
  public_network_access_enabled = local.public_network_access_enabled
  authorized_ips                = local.authorized_ips
  ip_restriction_headers        = var.ip_restriction_headers
  authorized_subnet_ids         = var.authorized_subnet_ids
  authorized_service_tags       = var.authorized_service_tags
  scm_ip_restriction_headers    = var.scm_ip_restriction_headers
  scm_authorized_ips            = local.scm_authorized_ips
  scm_authorized_subnet_ids     = var.scm_authorized_subnet_ids
  scm_authorized_service_tags   = var.scm_authorized_service_tags

  app_service_vnet_integration_subnet_id = var.app_service_vnet_integration_subnet_id
  app_service_pe_subnet_id               = var.app_service_pe_subnet_id
  privatedns_resource_group_name         = var.privatedns_resource_group_name

  backup_enabled                   = var.backup_enabled
  backup_custom_name               = var.backup_custom_name
  backup_storage_account_rg        = var.backup_storage_account_rg
  backup_storage_account_name      = var.backup_storage_account_name
  backup_storage_account_container = var.backup_storage_account_container
  backup_frequency_interval        = var.backup_frequency_interval
  backup_retention_period_in_days  = var.backup_retention_period_in_days
  backup_frequency_unit            = var.backup_frequency_unit
  backup_keep_at_least_one_backup  = var.backup_keep_at_least_one_backup

  application_insights_custom_name         = var.application_insights_custom_name
  application_insights_sampling_percentage = var.application_insights_sampling_percentage
  application_insights_id                  = var.application_insights_id
  application_insights_enabled             = var.application_insights_enabled
  application_insights_type                = var.application_insights_type
  application_insights_workspace_id        = var.application_insights_workspace_id

  app_service_logs = var.app_service_logs

  identity = var.identity

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags
}

module "container_web_app" {
  for_each = toset(lower(var.os_type) == "container" ? ["enabled"] : [])

  source = "./modules/container-web-app"

  providers = {
    azurerm = azurerm
  }

  workload = var.workload

  unique              = var.unique
  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name

  use_caf_naming                  = var.use_caf_naming
  name_prefix                     = var.name_prefix
  name_suffix                     = var.name_suffix
  app_service_custom_name         = var.app_service_custom_name
  custom_diagnostic_settings_name = var.custom_diagnostic_settings_name

  service_plan_id                = local.service_plan_id
  web_app_key_vault_id           = var.web_app_key_vault_id
  skip_identity_role_assignments = var.skip_identity_role_assignments
  docker_image                   = var.docker_image

  app_settings       = var.app_settings
  site_config        = var.site_config
  auth_settings      = var.auth_settings
  auth_settings_v2   = var.auth_settings_v2
  connection_strings = var.connection_strings
  sticky_settings    = var.sticky_settings

  mount_points               = var.mount_points
  client_affinity_enabled    = var.client_affinity_enabled
  https_only                 = var.https_only
  client_certificate_enabled = var.client_certificate_enabled

  staging_slot_enabled             = var.staging_slot_enabled
  staging_slot_custom_name         = var.staging_slot_custom_name
  staging_slot_custom_app_settings = var.staging_slot_custom_app_settings

  custom_domains                = var.custom_domains
  public_network_access_enabled = local.public_network_access_enabled
  authorized_ips                = local.authorized_ips
  ip_restriction_headers        = var.ip_restriction_headers
  authorized_subnet_ids         = var.authorized_subnet_ids
  authorized_service_tags       = var.authorized_service_tags
  scm_ip_restriction_headers    = var.scm_ip_restriction_headers
  scm_authorized_ips            = local.scm_authorized_ips
  scm_authorized_subnet_ids     = var.scm_authorized_subnet_ids
  scm_authorized_service_tags   = var.scm_authorized_service_tags

  app_service_vnet_integration_subnet_id = var.app_service_vnet_integration_subnet_id
  app_service_pe_subnet_id               = var.app_service_pe_subnet_id
  privatedns_resource_group_name         = var.privatedns_resource_group_name

  backup_enabled                   = var.backup_enabled
  backup_custom_name               = var.backup_custom_name
  backup_storage_account_rg        = var.backup_storage_account_rg
  backup_storage_account_name      = var.backup_storage_account_name
  backup_storage_account_container = var.backup_storage_account_container
  backup_frequency_interval        = var.backup_frequency_interval
  backup_retention_period_in_days  = var.backup_retention_period_in_days
  backup_frequency_unit            = var.backup_frequency_unit
  backup_keep_at_least_one_backup  = var.backup_keep_at_least_one_backup

  application_insights_custom_name         = var.application_insights_custom_name
  application_insights_sampling_percentage = var.application_insights_sampling_percentage
  application_insights_id                  = var.application_insights_id
  application_insights_enabled             = var.application_insights_enabled
  application_insights_type                = var.application_insights_type
  application_insights_workspace_id        = var.application_insights_workspace_id

  app_service_logs = var.app_service_logs

  identity = var.identity

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags
}

module "windows_web_app" {
  for_each = toset(lower(var.os_type) == "windows" ? ["enabled"] : [])

  source = "./modules/windows-web-app"

  providers = {
    azurerm = azurerm
  }

  workload = var.workload

  unique              = var.unique
  location            = var.location
  location_short      = var.location_short
  resource_group_name = var.resource_group_name

  use_caf_naming                  = var.use_caf_naming
  name_prefix                     = var.name_prefix
  name_suffix                     = var.name_suffix
  app_service_custom_name         = var.app_service_custom_name
  custom_diagnostic_settings_name = var.custom_diagnostic_settings_name

  service_plan_id                = local.service_plan_id
  web_app_key_vault_id           = var.web_app_key_vault_id
  skip_identity_role_assignments = var.skip_identity_role_assignments

  app_settings       = var.app_settings
  site_config        = var.site_config
  auth_settings      = var.auth_settings
  auth_settings_v2   = var.auth_settings_v2
  connection_strings = var.connection_strings
  sticky_settings    = var.sticky_settings

  mount_points               = var.mount_points
  client_affinity_enabled    = var.client_affinity_enabled
  https_only                 = var.https_only
  client_certificate_enabled = var.client_certificate_enabled

  staging_slot_enabled             = var.staging_slot_enabled
  staging_slot_custom_name         = var.staging_slot_custom_name
  staging_slot_custom_app_settings = var.staging_slot_custom_app_settings

  custom_domains                = var.custom_domains
  public_network_access_enabled = local.public_network_access_enabled
  authorized_ips                = local.authorized_ips
  ip_restriction_headers        = var.ip_restriction_headers
  authorized_subnet_ids         = var.authorized_subnet_ids
  authorized_service_tags       = var.authorized_service_tags
  scm_ip_restriction_headers    = var.scm_ip_restriction_headers
  scm_authorized_ips            = local.scm_authorized_ips
  scm_authorized_subnet_ids     = var.scm_authorized_subnet_ids
  scm_authorized_service_tags   = var.scm_authorized_service_tags

  app_service_vnet_integration_subnet_id = var.app_service_vnet_integration_subnet_id
  app_service_pe_subnet_id               = var.app_service_pe_subnet_id
  privatedns_resource_group_name         = var.privatedns_resource_group_name

  backup_enabled                   = var.backup_enabled
  backup_custom_name               = var.backup_custom_name
  backup_storage_account_rg        = var.backup_storage_account_rg
  backup_storage_account_name      = var.backup_storage_account_name
  backup_storage_account_container = var.backup_storage_account_container
  backup_frequency_interval        = var.backup_frequency_interval
  backup_retention_period_in_days  = var.backup_retention_period_in_days
  backup_frequency_unit            = var.backup_frequency_unit
  backup_keep_at_least_one_backup  = var.backup_keep_at_least_one_backup

  application_insights_custom_name         = var.application_insights_custom_name
  application_insights_sampling_percentage = var.application_insights_sampling_percentage
  application_insights_id                  = var.application_insights_id
  application_insights_workspace_id        = var.application_insights_workspace_id
  application_insights_enabled             = var.application_insights_enabled
  application_insights_type                = var.application_insights_type

  app_service_logs = var.app_service_logs

  identity = var.identity

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags
}
