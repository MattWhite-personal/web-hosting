terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.47.0"
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
  features {}
  use_oidc = true
}

locals {
  tags = {
    source     = "terraform"
    managed    = "as-code"
    repository = var.repository
  }
}
