## In order to read from Entra ID, the SP / App Registration running the TF deployment needs to have directory.read.all delegated permissions.
## These permissions can be set in the api permissions blade of the App Registration running the TF deployment.
## When these permissions cannot be set, use the object_id instead of the display_name or upn (for type User). 

data "azuread_group" "group" {
  for_each     = { for gr in local.role_assignments_flattened : gr.key => gr if gr.type == "Group" && gr.object_id == null }
  display_name = each.value.display_name
}

data "azuread_service_principal" "sp" {
  for_each     = { for sp in local.role_assignments_flattened : sp.key => sp if sp.type == "ServicePrincipal" || sp.type == "Application" && sp.object_id == null }
  display_name = each.value.display_name
}

data "azuread_user" "user" {
  for_each            = { for user in local.role_assignments_flattened : user.key => user if user.type == "User" && user.object_id == null }
  user_principal_name = each.value.upn
}

resource "azurerm_role_assignment" "role" {
  for_each = { for ra in local.role_assignments_flattened : ra.key => ra if ra.object_id == null }

  scope                = each.value.scope
  role_definition_name = each.value.role
  principal_id         = each.value.type == "Group" ? data.azuread_group.group[each.key].object_id : each.value.type == "User" ? data.azuread_user.user[each.key].object_id : data.azuread_service_principal.sp[each.key].object_id
}

resource "azurerm_role_assignment" "role_object_id" {
  for_each = { for ra in local.role_assignments_flattened : ra.key => ra if ra.object_id != null }

  scope                = each.value.scope
  role_definition_name = each.value.role
  principal_id         = each.value.object_id
}
