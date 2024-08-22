output "role_assignments" {
  value = azurerm_role_assignment.role
}

output "role_definitions" {
  value = azurerm_role_definition.custom
}
