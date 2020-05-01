resource "azurerm_app_service_plan" "plan" {
  name                = "appserviceplan-linux"
  location            = var.location
  resource_group_name = basename(azurerm_resource_group.rg.id)
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service_plan" "plan-consumption" {
  name                = "appserviceplan-linux2"
  location            = var.location
  resource_group_name = basename(azurerm_resource_group.rg.id)
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}
