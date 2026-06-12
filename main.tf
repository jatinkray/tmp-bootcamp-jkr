terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "northeurope"
}

variable "resource_group_name" {
  type    = string
  default = "Bootcamp"
}

resource "azurerm_resource_group" "bootcamp" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "random_password" "postgres" {
  length           = 16
  special          = false
}

module "postgresql" {
  source = "./modules/postgresql"

  resource_group_name = azurerm_resource_group.bootcamp.name
  location            = azurerm_resource_group.bootcamp.location
  server_name         = "bootcamp-postgres-tmp-jkr"
  admin_username      = "psqladmin"
  admin_password      = random_password.postgres.result
}

module "aks" {
  source = "./modules/aks"

  resource_group_name = azurerm_resource_group.bootcamp.name
  location            = azurerm_resource_group.bootcamp.location
  cluster_name        = "bootcamp-aks-tmp-jkr"
  dns_prefix          = "bootcampaks"
  node_count          = 3
  vm_size             = "Standard_B2s"
}

output "postgresql_fqdn" {
  value = module.postgresql.fqdn
}

output "aks_cluster_name" {
  value = module.aks.cluster_name
}

output "postgres_password" {
  value     = random_password.postgres.result
  sensitive = true
}
