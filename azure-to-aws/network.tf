locals {
  // we create a network with two address spaces - one for node pool subnets and one for services, gateways etc.
  address_spaces = ["172.29.0.0/23"]
  // node pool subnets
  subnet_cidrs = ["172.29.0.0/24", "172.29.1.0/24"]
  subnet_names = [var.name, "GatewaySubnet"]

  // app and services
  service_cidr   = "10.0.0.0/24"
  dns_service_ip = "10.0.0.10"

  tags = {}
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  address_spaces      = local.address_spaces

  vnet_name = var.name

  // we create three subnets - one for the nodes, one for ingresses and one for pods
  subnet_prefixes = local.subnet_cidrs
  subnet_names    = local.subnet_names

  subnet_service_endpoints = {
    "${var.name}" : ["Microsoft.Storage"]
  }
  use_for_each = true
  tags         = local.tags
}


data "azurerm_subnet" "snet" {
  name                 = "${var.name}-GatewaySubnet"
  virtual_network_name = module.network.vnet_name
  resource_group_name  = azurerm_resource_group.rg.name

  depends_on = [module.network]
}

