output "mjw-pip" {
  value = azurerm_public_ip.mjwsite.id
}

output "dev-swa" {
  value = azurerm_static_web_app.matthewjwhite-dev.default_host_name
}

output "mjw-dns-txt" {
  value     = azurerm_static_web_app_custom_domain.matthewjwhite-co-uk.validation_token
  sensitive = true
}

output "mjw-swa-id" {
  value = azurerm_static_web_app.matthewjwhite-co-uk.id
}
