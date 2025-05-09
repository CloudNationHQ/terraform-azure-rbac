# existing
data "azuread_group" "group" {
  for_each = {
    for gr in local.role_assignments :
    gr.key => gr if gr.type == "Group" && gr.object_id == null
  }

  display_name               = each.value.display_name
  include_transitive_members = try(each.value.include_transitive_members, false)
  mail_enabled               = try(each.value.mail_enabled, null)
  mail_nickname              = try(each.value.mail_nickname, null)
  security_enabled           = try(each.value.security_enabled, null)
  object_id                  = try(each.value.object_id, null)
}

data "azuread_service_principal" "sp" {
  for_each = {
    for sp in local.role_assignments :
    sp.key => sp if(sp.type == "ServicePrincipal" || sp.type == "Application") && sp.object_id == null
  }

  display_name = each.value.display_name
  client_id    = try(each.value.client_id, null)
  object_id    = try(each.value.object_id, null)
}

data "azuread_user" "user" {
  for_each = {
    for user in local.role_assignments :
    user.key => user if user.type == "User" && user.object_id == null
  }

  user_principal_name = each.value.upn
  object_id           = try(each.value.object_id, null)
  mail_nickname       = try(each.value.mail_nickname, null)
  mail                = try(each.value.mail, null)
  employee_id         = try(each.value.employee_id, null)
}

data "azurerm_role_definition" "custom" {
  for_each = {
    for rd in local.role_assignments :
    rd.role => rd if rd.existing_role_definition == true
  }

  name               = each.value.role
  scope              = each.value.scope
  role_definition_id = try(each.value.role_definition_id, null)
}

# role assignments
resource "azurerm_role_assignment" "role" {
  for_each = {
    for ra in local.role_assignments :
    ra.key => ra if ra.object_id == null
  }

  scope                                  = each.value.scope
  role_definition_name                   = [for rd in var.role_definitions : rd] != each.value.role && each.value.existing_role_definition == false ? each.value.role : null
  role_definition_id                     = [for rd in var.role_definitions : rd] == each.value.role ? azurerm_role_definition.custom[each.value.role].role_definition_id : each.value.existing_role_definition == true ? data.azurerm_role_definition.custom[each.value.role].role_definition_id : null
  principal_id                           = each.value.type == "Group" ? data.azuread_group.group[each.key].object_id : each.value.type == "User" ? data.azuread_user.user[each.key].object_id : data.azuread_service_principal.sp[each.key].object_id
  principal_type                         = try(each.value.type, null)
  description                            = try(each.value.description, null)
  skip_service_principal_aad_check       = try(each.value.skip_service_principal_aad_check, false)
  condition                              = try(each.value.condition, null)
  condition_version                      = try(each.value.condition_version, null)
  delegated_managed_identity_resource_id = try(each.value.delegated_managed_identity_resource_id, null)

  depends_on = [azurerm_role_definition.custom]
}

resource "azurerm_role_assignment" "role_object_id" {
  for_each = {
    for ra in local.role_assignments :
    ra.key => ra if ra.object_id != null
  }

  scope                                  = each.value.scope
  role_definition_name                   = [for rd in var.role_definitions : rd] != each.value.role && each.value.existing_role_definition == false ? each.value.role : null
  role_definition_id                     = [for rd in var.role_definitions : rd] == each.value.role ? azurerm_role_definition.custom[each.value.role].role_definition_id : each.value.existing_role_definition == true ? data.azurerm_role_definition.custom[each.value.role].role_definition_id : null
  principal_id                           = each.value.object_id
  principal_type                         = try(each.value.type, null)
  description                            = try(each.value.description, null)
  skip_service_principal_aad_check       = try(each.value.skip_service_principal_aad_check, false)
  condition                              = try(each.value.condition, null)
  condition_version                      = try(each.value.condition_version, null)
  delegated_managed_identity_resource_id = try(each.value.delegated_managed_identity_resource_id, null)

  depends_on = [azurerm_role_definition.custom]
}

resource "azurerm_role_definition" "custom" {
  for_each = {
    for key, rd in var.role_definitions : key => rd
  }

  name               = try(each.value.role, each.key)
  scope              = each.value.scope
  role_definition_id = try(each.value.role_definition_id, null)
  description        = try(each.value.description, null)

  assignable_scopes = each.value.assignable_scopes

  dynamic "permissions" {
    for_each = try(each.value.permissions, null) != null ? { default = each.value.permissions } : {}
    content {
      actions          = try(permissions.value.actions, null)
      not_actions      = try(permissions.value.not_actions, null)
      data_actions     = try(permissions.value.data_actions, null)
      not_data_actions = try(permissions.value.not_data_actions, null)
    }
  }
}
