provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "eastus"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = "172.16.4.0/24"
  subnet_prefixes     = ["172.16.4.0/24"]
  subnet_names        = ["subnet1"]
  depends_on          = [azurerm_resource_group.rg]
}

module "aks" {
  source              = "Azure/aks/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  client_id           = var.client_id
  client_secret       = var.client_secret
  prefix              = var.prefix
  vnet_subnet_id      = module.network.vnet_subnets[0]
  os_disk_size_gb     = 50
  agents_count        = 1
  enable_log_analytics_workspace = false


  depends_on = [module.network]
}
