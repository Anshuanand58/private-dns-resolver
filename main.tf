data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "dns" {
  count               = var.private_dns_zone_name == null ? 0 : 1
  name                = var.private_dns_zone_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_virtual_network" "vnet" {
  name                = lower("${var.virtual_network_name}")
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Creating Inbound Subnet, note there is only support for two inbound endpoints per DNS Resolver, and they cannot share the same subnet.

data "azurerm_subnet" "inbound" {
  name                 = lower("${var.subnet_name1}")
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Creating Outbound Subnet, note there is only support for two outbound endpoints per DNS Resolver, and they cannot share the same subnet.
data "azurerm_subnet" "outbound" {
  name                 = lower("${var.subnet_name2}")
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_resolver" "private_dns_resolver" {
  name                = var.dns_resolver_name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = data.azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound_endpoint" {
  name                    = "inbound"
  location                = var.location
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = data.azurerm_subnet.inbound.id
  }
}

# Outbound Endpoints
resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound_endpoint" {
  name                    = "outbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.private_dns_resolver.id
  location                = var.location
  subnet_id               = data.azurerm_subnet.outbound.id

}

# Inbound Forwarding Rulesets
# resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "inbound_ruleset" {
#   name                                       = var.inbound_ruleset
#   resource_group_name                        = data.azurerm_resource_group.rg.name
#   location                                   = var.location
#   private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.id]
# }

# Outbound Forwarding Rulesets
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "outbound_ruleset" {
  name                                       = var.outbound_ruleset
  resource_group_name                        = data.azurerm_resource_group.rg.name
  location                                   = var.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound_endpoint.id]
}
