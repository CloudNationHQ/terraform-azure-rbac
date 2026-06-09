output "role_assignments" {
  value = azurerm_role_assignment.this
}

output "role_definitions" {
  value = azurerm_role_definition.custom
}
