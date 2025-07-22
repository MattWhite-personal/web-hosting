resource "azurerm_static_web_app" "matthewjwhite-dev" {
  name                = "matthewjwhite-dev"
  resource_group_name = azurerm_resource_group.webservers.name
  location            = "westeurope"
  sku_size            = "Standard"
  sku_tier            = "Standard"
  tags                = local.tags

  lifecycle {
    ignore_changes = [
      repository_branch,
      repository_url,
      repository_token
    ]
  }
}

resource "azurerm_static_web_app_custom_domain" "matthewjwhite-dev" {
  static_web_app_id = azurerm_static_web_app.matthewjwhite-dev.id
  domain_name       = "dev.matthewjwhite.co.uk"
  validation_type   = "cname-delegation"
}

resource "azurerm_static_web_app" "matthewjwhite-co-uk" {
  name                = "matthewjwhite-co-uk"
  resource_group_name = azurerm_resource_group.webservers.name
  location            = "westeurope"
  sku_size            = "Standard"
  sku_tier            = "Standard"
  tags                = local.tags

  lifecycle {
    ignore_changes = [
      repository_branch,
      repository_url,
      repository_token
    ]
  }
}

resource "azurerm_static_web_app_custom_domain" "matthewjwhite-co-uk" {
  static_web_app_id = azurerm_static_web_app.matthewjwhite-co-uk.id
  domain_name       = "matthewjwhite.co.uk"
  validation_type   = "dns-txt-token"
}
