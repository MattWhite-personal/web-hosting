terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.7.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "stwhitefamterraform"
    container_name = "tfstate"
    key            = "web-hosting.tfstate"
  }
}
provider "azurerm" {

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {

  }
}

locals {
  tags = {
    source  = "terraform"
    managed = "as-code"
  }
}