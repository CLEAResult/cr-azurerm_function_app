variable "rgid" {
  type        = string
  description = "RGID used for naming"
}

variable "location" {
  type        = string
  default     = "southcentralus"
  description = "Location for resources to be created"
}

variable "num" {
  type    = number
  default = 1
}

variable "name_prefix" {
  type        = string
  default     = ""
  description = "Allows users to override the standard naming prefix.  If left as an empty string, the standard naming conventions will apply."
}

variable "name_suffix" {
  type        = string
  default     = ""
  description = "Allows users to override the standard naming suffix, appearing after the instance count.  If left as an empty string, the standard naming conventions will apply."
}

variable "name_override" {
  type        = string
  default     = ""
  description = "If non-empty, will override all the standard naming conventions.  This should only be used when a product requires a specific database name."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment used in naming lookups"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "subscription_id" {
  type        = string
  description = "Prompt for subscription ID"
}

variable "use_msi" {
  type        = bool
  default     = false
  description = "Use Managed Identity authentication for azurerm terraform provider. Default is false."
}

variable "plan" {
  type        = string
  description = "Full Azure App Service Plan resource ID."
}

variable "function_version" {
  type        = string
  default     = "~2"
  description = "Runtime version of Azure Function App.  Values are '~1', '~2', '~3'."
}

variable "functions_worker_runtime" {
  type = string

  default     = "dotnet"
  description = "The language worker runtime to load into the function app.  Valid values are 'dotnet','node','java','powershell', 'python'.  The default value is 'dotnet'."
}

variable "website_run_from_package" {
  type        = string
  default     = "0"
  description = "This enables your function app to run from a mounted package file.  See documentation for instructions"
}

variable "enable_builtin_logging" {
  type        = bool
  default     = false
  description = "This determines whether to enable builtin logging.  The default is false, under the premise that the function logs to Application Insights."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the web app."
}

## Storage Account ##
variable "account_kind" {
  type        = string
  default     = "StorageV2"
  description = "Valid values are:  Storage,BlobStorage,StorageV2"
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "Valid values are:  Standard,Premium"
}

variable "account_replication_type" {
  type        = string
  default     = ""
  description = "Valid values are: LRS, ZRS, GRS, RAGRS"
}

variable "access_tier" {
  type        = string
  default     = "cool"
  description = "Valid values are: Cool, Hot"
}

# Compute default name values
locals {
  plan_name = split("/", var.plan)[8]
  plan_rg   = split("/", var.plan)[4]

  env_id = lookup(module.naming.env-map, var.environment, "env")
  type   = lookup(module.naming.type-map, "azurerm_function_app", "typ")

  rg_type = lookup(module.naming.type-map, "azurerm_resource_group", "typ")

  default_rgid        = var.rgid != "" ? var.rgid : "norgid"
  default_name_prefix = format("c%s%s", local.default_rgid, local.env_id)

  name_prefix = var.name_prefix != "" ? var.name_prefix : local.default_name_prefix
  name        = format("%s%s", local.name_prefix, local.type)

  storage_account_type = lookup(module.naming.type-map, "azurerm_storage_account", "typ")
  storage_account_name = format("%s%s", local.name_prefix, local.storage_account_type)

  default_account_replication_type = local.env_id == "p" ? "GRS" : "LRS"
  account_replication_type         = var.account_replication_type == "" ? local.default_account_replication_type : var.account_replication_type
}

# This module provides a data map output to lookup naming standard references
module "naming" {
  source = "git::https://github.com/CLEAResult/cr-azurerm-naming.git?ref=v1.1.3"
}
