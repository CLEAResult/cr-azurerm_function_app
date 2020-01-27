resource "azurerm_function_app" "functionapp" {
  name                      = format("%s%03d", local.name, count.index + 1)
  count                     = var.num
  location                  = var.location
  resource_group_name       = var.rg_name
  app_service_plan_id       = local.plan
  storage_connection_string = local.storage_connection_string
  enable_builtin_logging    = var.enable_builtin_logging
  version                   = var.function_version

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = var.functions_worker_runtime
    WEBSITE_RUN_FROM_PACKAGE = var.website_run_from_package
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  tags = merge({
    InfrastructureAsCode = "True"
  }, var.tags)
}

resource "azurerm_storage_account" "storageaccount" {
  name                      = format("%s%03dfa", local.storage_account_name, count.index + 1)
  count                     = var.num
  resource_group_name       = var.rg_name
  location                  = var.location
  enable_https_traffic_only = true
  enable_blob_encryption    = true
  enable_file_encryption    = true
  account_kind              = var.account_kind
  access_tier               = var.access_tier
  account_replication_type  = local.account_replication_type
  account_tier              = var.account_tier

  tags = merge({
    InfrastructureAsCode = "True"
  }, var.tags)
}

data "azurerm_storage_account" "storageaccount" {
  name                = azurerm_storage_account.storageaccount.0.name
  resource_group_name = var.rg_name
  depends_on          = [azurerm_storage_account.storageaccount]
}

data "azurerm_client_config" "current" {}
