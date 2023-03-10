module "dnsresolver" {
  source                = "../dns"
  private_dns_zone_name = "mypvtdns.com"
  resource_group_name   = var.resource_group_name
  location              = var.location
  dns_resolver_name     = var.dns_resolver_name
  inbound_ruleset       = var.inbound_ruleset
  outbound_ruleset      = var.outbound_ruleset
  virtual_network_name  = "dns-vnet"
}
