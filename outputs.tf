output "name" {
  value = azurerm_storage_account.storageaccount.*.name
  #value = azurerm_storage_account.storageaccount.*.name
}
