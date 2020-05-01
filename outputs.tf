output "id" {
  value = azurerm_function_app.functionapp.*.id
}

output "app_service_default_url" {
  value = azurerm_function_app.functionapp.*.default_hostname
}

output "outbound_ip_addresses" {
  value = azurerm_function_app.functionapp.*.outbound_ip_addresses
}

#output "msi_principal_id" {
#  value = azurerm_function_app.functionapp[0].identity[0].principal_id
#}

#output "msi_tenant_id" {
#  value = azurerm_function_app.functionapp[0].identity[0].tenant_id
#}

output "kind" {
  value = azurerm_function_app.functionapp.*.kind
}

output "storage_account_name" {
  value = azurerm_storage_account.storageaccount.*.name
}
