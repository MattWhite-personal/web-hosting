terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.41.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-whitefam-terraform"
    storage_account_name = "stwhitefamterraform"
    container_name       = "tfstate"
    key                  = "web-hosting.tfstate"
    use_oidc             = true
  }
}
provider "azurerm" {

  #subscription_id = var.subscription_id
  #tenant_id       = var.tenant_id
  #client_id       = var.client_id
  #client_secret   = var.client_secret
  features {}
  use_oidc = true
}

locals {
  tags = {
    source  = "terraform"
    managed = "as-code"
  }
}
