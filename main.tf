data "azuread_group" "this" {
  for_each = {
    for k, v in local.assignments : k => v
    if v.type == "Group" && v.display_name != null
  }

  display_name               = each.value.display_name
  include_transitive_members = each.value.include_transitive_members
  mail_enabled               = each.value.mail_enabled
  mail_nickname              = each.value.mail_nickname
  security_enabled           = each.value.security_enabled
  object_id                  = each.value.object_id
}


data "azuread_service_principal" "this" {
  for_each = {
    for k, v in local.assignments : k => v
    if(v.type == "ServicePrincipal" || v.type == "Application") && v.display_name != null
  }

  display_name = each.value.display_name
  client_id    = each.value.client_id
  object_id    = each.value.object_id
}

data "azuread_user" "this" {
  for_each = {
    for k, v in local.assignments : k => v
    if v.type == "User" && v.upn != null
  }

  user_principal_name = each.value.upn
  object_id           = each.value.object_id
  mail_nickname       = each.value.mail_nickname
  mail                = each.value.mail
  employee_id         = each.value.employee_id
}

data "azurerm_role_definition" "custom" {
  for_each = {
    for k, v in local.assignments : k => v
    if v.existing_role_definition == true
  }

  name               = each.value.role
  scope              = each.value.scope
  role_definition_id = each.value.role_definition_id
}


# role assignments
resource "azurerm_role_assignment" "this" {
  for_each = local.assignments

  name                 = each.value.assignment_id
  scope                = each.value.scope
  role_definition_name = !each.value.existing_role_definition ? coalesce(try(var.role_definitions[each.value.role].name, null), each.value.role) : null
  role_definition_id   = each.value.existing_role_definition ? data.azurerm_role_definition.custom[each.key].role_definition_id : null
  principal_id = each.value.display_name != null || each.value.upn != null ? (
    each.value.type == "Group" ? data.azuread_group.this[each.key].object_id :
    each.value.type == "User" ? data.azuread_user.this[each.key].object_id :
    data.azuread_service_principal.this[each.key].object_id
  ) : each.value.object_id
  principal_type                         = each.value.type == "Application" ? "ServicePrincipal" : each.value.type
  description                            = each.value.description
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id

  depends_on = [azurerm_role_definition.custom]
}

# role definitions
resource "azurerm_role_definition" "custom" {
  for_each = var.role_definitions

  name               = coalesce(each.value.name, each.key)
  scope              = each.value.scope
  role_definition_id = each.value.role_definition_id
  description        = each.value.description

  assignable_scopes = each.value.assignable_scopes

  dynamic "permissions" {
    for_each = each.value.permissions != null ? { default = each.value.permissions } : {}
    content {
      actions          = permissions.value.actions
      not_actions      = permissions.value.not_actions
      data_actions     = permissions.value.data_actions
      not_data_actions = permissions.value.not_data_actions
    }
  }
}
