terraform {
    required_providers {
        azurerm = {
        source  = "hashicorp/azurerm"
        version = "=2.91.0"
        }
    }
    backend "azurerm" {
        resource_group_name  = "rg-dev"
        storage_account_name = "nftestsatfstatedev"
        container_name       = "sctfstatedev"
        key                  = "terraform.tfstate"
        # access key property left out - it is stored as an env var called ARM_ACCESS_KEY
    } 
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "mainrg" {
  name     = "rg-${var.env}"
  location = var.location
}

resource "azurerm_storage_account" "sa-tfstate" {
  name                     = "nftestsatfstate${var.env}"
  resource_group_name      = azurerm_resource_group.mainrg.name
  location                 = azurerm_resource_group.mainrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "sc-tfstateexample" {
  name                  = "sctfstate${var.env}"
  storage_account_name  = azurerm_storage_account.sa-tfstate.name
  container_access_type = "private"
}