resource "azurerm_private_endpoint" "main_pe" {
  count               = var.app_service_pe_subnet_id != null ? 1 : 0
  location            = azurerm_linux_web_app.app_service_linux.location
  name                = "${azurerm_linux_web_app.app_service_linux.name}-pe"
  resource_group_name = var.resource_group_name
  subnet_id           = var.app_service_pe_subnet_id

  private_service_connection {
    name                           = azurerm_linux_web_app.app_service_linux.name
    private_connection_resource_id = azurerm_linux_web_app.app_service_linux.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  lifecycle {
    # Avoid recreation of the private endpoint due to moving to central module
    ignore_changes = [
      private_service_connection[0].name,
      private_dns_zone_group,
    ]
  }
}

removed {
  from = azurerm_private_dns_a_record.main
  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_private_dns_a_record.main_scm
  lifecycle {
    destroy = false
  }
}

