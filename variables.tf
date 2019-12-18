variable "rgid" {
  description = "RGID used for naming"
}

variable "location" {
  default     = "southcentralus"
  description = "Location for resources to be created"
}

variable "num" {
  default = 1
}

variable "name_prefix" {
  default     = ""
  description = "Allows users to override the standard naming prefix.  If left as an empty string, the standard naming conventions will apply."
}

variable "environment" {
  default     = "dev"
  description = "Environment used in naming lookups"
}

variable "rg_name" {
  description = "Resource group name"
}

variable "subscription_id" {
  description = "Prompt for subscription ID"
}

variable "plan" {
  default     = ""
  description = "Full Azure App Service Plan resource ID.  Either 'plan' or 'plan_name' and 'plan_rg' must be set. 'Plan' takes precendence."
}

variable "plan_name" {
  default     = ""
  description = "Azure App Service Plan name.  Either 'plan' or 'plan_name' and 'plan_rg' must be set. 'Plan' takes precendence."
}

variable "plan_rg" {
  default     = ""
  description = "Azure App Service Plan resource group name.  Either 'plan' or 'plan_name' and 'plan_rg' must be set. 'Plan' takes precendence."
}


variable "storage_account_id" {
  default     = ""
  description = "."
}

variable "storage_account_name" {
  default     = ""
  description = "."
}

variable "storage_account_resource_group" {
  default     = ""
  description = "."
}

variable "storage_connection_string" {
  description = "."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the web app."
}

# Compute default name values
locals {
  plan_name = var.plan != "" ? split("/", var.plan)[8] : var.plan_name
  plan_rg = var.plan != "" ? split("/", var.plan)[4] : var.plan_rg
  plan = var.plan != "" ? var.plan : format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Web/serverFarms/%s", data.azurerm_client_config.current.subscription_id, var.plan_rg, var.plan_name)

  #storage_account_name           = var.storage_account_id != "" ? split("/", var.storage_account_id)[8] : var.storage_account_name
  #storage_account_resource_group = var.storage_account_id != "" ? split("/", var.storage_account_id)[4] : var.storage_account_resource_group
  #storage_account                = var.storage_account_id != "" ? var.storage_account_id : format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Storage/storageAccounts/%s", data.azurerm_client_config.current.subscription_id, var.storage_account_resource_group, var.storage_account_name)


  env_id = lookup(module.naming.env-map, var.environment, "env")
  type   = lookup(module.naming.type-map, "azurerm_function_app", "typ")

  rg_type = lookup(module.naming.type-map, "azurerm_resource_group", "typ")

  default_rgid        = var.rgid != "" ? var.rgid : "norgid"
  default_name_prefix = format("c%s%s", local.default_rgid, local.env_id)

  name_prefix = var.name_prefix != "" ? var.name_prefix : local.default_name_prefix
  name        = format("%s%s", local.name_prefix, local.type)

  #storage_connection_string = data.azurerm_storage_account.storageaccount.primary_connection_string

}

# This module provides a data map output to lookup naming standard references
module "naming" {
  source = "git::https://github.com/CLEAResult/cr-azurerm-naming.git?ref=v1.1.1"
}
