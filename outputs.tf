output "role_assignments" {
  value = azurerm_role_assignment.this
}

output "role_assignment_object_ids" {
  value = azurerm_role_assignment.role_object_id
}

output "role_definitions" {
  value = azurerm_role_definition.custom
}
