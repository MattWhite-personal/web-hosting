output "mjw-pip" {
  value = azurerm_public_ip.mjwsite.id
}

output "dev-swa" {
  value = azurerm_static_web_app.matthewjwhite-dev.default_host_name
}

