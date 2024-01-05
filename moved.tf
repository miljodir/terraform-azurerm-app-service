# Support migration from sub to root module

moved {
  from = azurerm_linux_web_app.app_service_linux
  to   = module.linux_web_app.module.linux_web_app["enabled"]
}

moved {
  from = azurerm_linux_web_app.app_service_linux
  to   = module.container_web_app.module.app_service_linux_container["enabled"]
}


moved {
  from = azurerm_windows_web_app.app_service_windows
  to   = module.windows_web_app.module.windows_web_app["enabled"]
}
