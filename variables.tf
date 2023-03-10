variable "resource_group_name" {
  type        = string
  description = "(Required): Name of the resource group where resources should be deployed."
}

variable "private_dns_zone_name" {
  type        = string
  description = "Pvt dns zone name"
}
variable "location" {
  type        = string
  description = "(Required): Region / Location where Azure DNS Resolver should be deployed"
}

variable "dns_resolver_name" {
  type        = string
  description = "(Required): Name of the Azure DNS Private Resolver"
}


# variable "inbound_endpoint_ip" {
#   type    = list(string)
#   default = ["10.1.2.4"]
# }

# variable "outbound_endpoint_ip" {
#   type    = list(string)
#   default = ["10.1.3.4"]
# }

variable "inbound_ruleset" {
  type = string
  default = "DC-to-Azure"
}


variable "outbound_ruleset" {
  type = string
  default = "Azure-to-DC"
}

variable "virtual_network_name" {
  type        = string
  default     = "dns-resolver"
  description = "Virtual Network Name"
}

variable "virtual_network_address_space" {
  type        = list(string)
  default     = ["10.1.0.0/23"]
  description = "List of all virtual network addresses"
}

variable "inbound_subnet_address_prefixes" {
  type        = list(string)
  default     = ["10.1.0.0/24"]
  description = "List of inbound subnet address prefixes"
}

variable "outbound_subnet_address_prefixes" {
  type        = list(string)
  default     = ["10.1.1.0/24"]
  description = "List of outbound subnet address prefixes"
}

variable "subnet_name1" {
  type    = string
  default = "subnet3"
}

variable "subnet_name2" {
  type    = string
  default = "subnet4"
}