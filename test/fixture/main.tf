provider "random" {
  version = "~> 2.1"
}

resource "random_string" "test" {
  length  = 9
  special = false
  upper   = false
  lower   = true
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  version         = "~> 1.40.0"
}

provider "azuread" {
  version = "~> 0.7.0"
}

resource "azurerm_resource_group" "rg" {
  name     = format("rg-%s", random_string.test.result)
  location = var.location
}

module "functionapp" {
  source          = "../../"
  rg_name         = basename(azurerm_resource_group.rg.id)
  rgid            = var.rgid
  plan            = azurerm_app_service_plan.plan.id
  environment     = var.environment
  location        = var.location
  subscription_id = var.subscription_id
  name_prefix     = "pref"
  name_suffix     = "suff"
}

module "functionapp-override" {
  source          = "../../"
  rg_name         = basename(azurerm_resource_group.rg.id)
  rgid            = var.rgid
  plan            = azurerm_app_service_plan.plan-consumption.id
  environment     = var.environment
  location        = var.location
  subscription_id = var.subscription_id
  name_override   = format("%s%s", random_string.test.result, random_string.test.result)
}


data "azurerm_client_config" "current" {}
