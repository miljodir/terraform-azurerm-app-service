resource "azurerm_app_service" "app_service" {
  name                = "${local.app_service_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  app_service_plan_id = "${module.app_service_plan.app_service_plan_id}"

  site_config = ["${merge(local.default_site_config, var.site_config)}"]

  app_settings = "${merge(local.default_app_settings, var.app_settings)}"

  connection_string = "${var.connection_string}"

  client_affinity_enabled = "${var.client_affinity_enabled}"
  https_only              = "${var.https_only}"
  client_cert_enabled     = "${var.client_cert_enabled}"

  tags = "${merge(local.default_tags, var.extra_tags)}"

  lifecycle {
    ignore_changes = [
      # Avoid to have changes if one of settings below is set - requires to apply twice :/
      "app_settings.%",

      # Automated diagnostics logs related settings
      "app_settings.DIAGNOSTICS_AZUREBLOBCONTAINERSASURL",

      "app_settings.DIAGNOSTICS_AZUREBLOBRETENTIONINDAYS",
      "app_settings.WEBSITE_HTTPLOGGING_CONTAINER_URL",
      "app_settings.WEBSITE_HTTPLOGGING_RETENTION_DAYS",

      # Java related settings, set at deployment
      "app_settings.INIT_SCRIPT",
    ]
  }
}
