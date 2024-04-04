resource "azurerm_public_ip" "pip_gw" {
  name                = "${var.name}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_virtual_network_gateway" "vpngw" {
  name = "${var.name}-vpngw"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  active_active       = false
  enable_bgp          = false

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip_gw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.snet.id
  }


  tags = local.tags

  depends_on = [module.network]
}

resource "azurerm_local_network_gateway" "localgw" {
  name                = var.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  gateway_address     = var.aws_gateway_address
  address_space       = var.aws_gateway_address_space

  tags = local.tags
}

resource "azurerm_virtual_network_gateway_connection" "az-hub-aws" {
  name                            = "${var.name}-localgw-connection"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  type                            = "IPsec"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id        = azurerm_local_network_gateway.localgw.id
  express_route_circuit_id        = null
  peer_virtual_network_gateway_id = null
  shared_key                      = var.aws_gateway_shared_key
  connection_protocol             = "IKEv2"

  tags = local.tags
}
