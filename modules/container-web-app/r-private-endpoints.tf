resource "azurerm_private_endpoint" "main_pe" {
  count               = var.app_service_pe_subnet_id != null ? 1 : 0
  location            = azurerm_linux_web_app.app_service_linux_container.location
  name                = "${azurerm_linux_web_app.app_service_linux_container.name}-pe"
  resource_group_name = var.resource_group_name
  subnet_id           = var.app_service_pe_subnet_id

  private_service_connection {
    name                           = azurerm_linux_web_app.app_service_linux_container.name
    private_connection_resource_id = azurerm_linux_web_app.app_service_linux_container.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  lifecycle {
    # Avoid recreation of the private endpoint due to moving to central module
    ignore_changes = [private_service_connection[0].name]
  }
}

resource "azurerm_private_dns_a_record" "main" {
  count               = var.app_service_pe_subnet_id != null ? 1 : 0
  name                = azurerm_linux_web_app.app_service_linux_container.name
  records             = [azurerm_private_endpoint.main_pe[0].private_service_connection[0].private_ip_address]
  resource_group_name = var.privatedns_resource_group_name
  ttl                 = 600
  zone_name           = "privatelink.azurewebsites.net"

  provider = azurerm.p-dns
}

resource "azurerm_private_dns_a_record" "main_scm" {
  count               = var.app_service_pe_subnet_id != null ? 1 : 0
  name                = "${azurerm_linux_web_app.app_service_linux_container.name}.scm"
  records             = [azurerm_private_endpoint.main_pe[0].private_service_connection[0].private_ip_address]
  resource_group_name = var.privatedns_resource_group_name
  ttl                 = 600
  zone_name           = "privatelink.azurewebsites.net"

  provider = azurerm.p-dns
}
