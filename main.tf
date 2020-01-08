resource "azurerm_function_app" "functionapp" {
  name                      = format("%s%03d", local.name, count.index + 1)
  count                     = var.num
  location                  = var.location
  resource_group_name       = var.rg_name
  app_service_plan_id       = local.plan
  storage_connection_string = var.storage_connection_string
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

data "azurerm_client_config" "current" {}
