output "role_assignments" {
  value = azurerm_role_assignment.role
}

output "role_definitions" {
  value = azurerm_role_definition.custom
}

output "role_management_policies" {
  value = azurerm_role_management_policy.role
}

output "pim_eligible_role_assignments" {
  value = azurerm_pim_eligible_role_assignment.role
}
