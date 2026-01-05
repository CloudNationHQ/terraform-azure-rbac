locals {
  assignments = {
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = principal.display_name
            include_transitive_members             = principal.include_transitive_members
            mail_enabled                           = principal.mail_enabled
            mail_nickname                          = principal.mail_nickname
            security_enabled                       = principal.security_enabled
            client_id                              = principal.client_id
            object_id                              = principal.object_id
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = principal.mail
            employee_id                            = principal.employee_id
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = role.existing_role_definition
            description                            = role.description
            skip_service_principal_aad_check       = role.skip_service_principal_aad_check
            condition                              = role.condition
            condition_version                      = role.condition_version
            delegated_managed_identity_resource_id = role.delegated_managed_identity_resource_id
            role_management_policy                 = try(scope.role_management_policy, scope.rmp)
            pim_eligible                           = try(scope.eligible, scope.pim_eligible, scope.pim)
          }
        ]
      ]
    ]) : assignment.key => assignment
  }
}

data "azuread_group" "group" {
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

data "azuread_group" "primary_approver" {
  for_each = {
    for item in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes :
          try(scope.role_management_policy.activation_rules.approval_stage, null) == null ? [] : [
            for idx, approver in try(
              tolist(scope.role_management_policy.activation_rules.approval_stage.primary_approver),
              scope.role_management_policy.activation_rules.approval_stage.primary_approver == null ? [] : [scope.role_management_policy.activation_rules.approval_stage.primary_approver]
              ) : {
              key  = format("%s-primary-%02d", format("%s-%s-%s", replace(principal_key, " ", "-"), replace(role_key, " ", "-"), scope_key), idx)
              type = lower(coalesce(try(approver.type, "Group"), "Group"))
              display_name = coalesce(
                try(approver.display_name, null),
                try(approver.group_display_name, null),
                try(approver.name, null)
              )
            }
          ]
        ]
      ]
    ]) : item.key => item
    if item.type == "group" && item.display_name != null
  }

  display_name = each.value.display_name
}

data "azuread_service_principal" "sp" {
  for_each = {
    for k, v in local.assignments : k => v
    if(v.type == "ServicePrincipal" || v.type == "Application") && v.display_name != null
  }

  display_name = each.value.display_name
  client_id    = each.value.client_id
  object_id    = each.value.object_id
}

data "azuread_user" "user" {
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
    for k, v in local.assignments : v.role => v
    if v.existing_role_definition == true
  }

  name  = each.value.role
  scope = each.value.scope
}

data "azurerm_role_definition" "builtin" {
  for_each = {
    for k, v in local.assignments : k => v
    if v.existing_role_definition == false && !contains(keys(var.role_definitions), v.role)
  }

  name  = each.value.role
  scope = each.value.scope
}

resource "azurerm_role_assignment" "role" {
  for_each = {
    for k, v in local.assignments : k => v
    if(v.display_name != null || v.upn != null) && v.pim_eligible == null
  }

  scope                                  = each.value.scope
  role_definition_name                   = !each.value.existing_role_definition && !contains(keys(var.role_definitions), each.value.role) ? each.value.role : null
  role_definition_id                     = contains(keys(var.role_definitions), each.value.role) ? azurerm_role_definition.custom[each.value.role].role_definition_id : each.value.existing_role_definition ? data.azurerm_role_definition.custom[each.value.role].role_definition_id : null
  principal_id                           = each.value.type == "Group" ? data.azuread_group.group[each.key].object_id : each.value.type == "User" ? data.azuread_user.user[each.key].object_id : data.azuread_service_principal.sp[each.key].object_id
  principal_type                         = each.value.type
  description                            = each.value.description
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id

  depends_on = [azurerm_role_definition.custom]
}

resource "azurerm_role_assignment" "role_object_id" {
  for_each = {
    for k, v in local.assignments : k => v
    if v.display_name == null && v.upn == null && v.pim_eligible == null
  }

  scope                                  = each.value.scope
  role_definition_name                   = !each.value.existing_role_definition && !contains(keys(var.role_definitions), each.value.role) ? each.value.role : null
  role_definition_id                     = contains(keys(var.role_definitions), each.value.role) ? azurerm_role_definition.custom[each.value.role].role_definition_id : each.value.existing_role_definition ? data.azurerm_role_definition.custom[each.value.role].role_definition_id : null
  principal_id                           = each.value.object_id
  principal_type                         = each.value.type
  description                            = each.value.description
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id

  depends_on = [azurerm_role_definition.custom]
}

resource "azurerm_role_management_policy" "role" {
  for_each = {
    for k, v in local.assignments : k => v
    if v.role_management_policy != null
  }

  scope              = each.value.scope
  role_definition_id = each.value.existing_role_definition ? data.azurerm_role_definition.custom[each.value.role].role_definition_id : contains(keys(var.role_definitions), each.value.role) ? azurerm_role_definition.custom[each.value.role].role_definition_id : data.azurerm_role_definition.builtin[each.key].role_definition_id

  dynamic "active_assignment_rules" {
    for_each = each.value.role_management_policy.active_assignment_rules != null ? [each.value.role_management_policy.active_assignment_rules] : []
    content {
      expiration_required                = active_assignment_rules.value.expiration_required
      expire_after                       = active_assignment_rules.value.expire_after
      require_justification              = active_assignment_rules.value.require_justification
      require_multifactor_authentication = active_assignment_rules.value.require_multifactor_authentication
      require_ticket_info                = active_assignment_rules.value.require_ticket_info
    }
  }

  dynamic "eligible_assignment_rules" {
    for_each = each.value.role_management_policy.eligible_assignment_rules != null ? [each.value.role_management_policy.eligible_assignment_rules] : []
    content {
      expiration_required = eligible_assignment_rules.value.expiration_required
      expire_after        = eligible_assignment_rules.value.expire_after
    }
  }

  dynamic "activation_rules" {
    for_each = each.value.role_management_policy.activation_rules != null ? [each.value.role_management_policy.activation_rules] : []
    content {
      maximum_duration                                   = activation_rules.value.maximum_duration
      require_approval                                   = activation_rules.value.require_approval
      require_justification                              = activation_rules.value.require_justification
      require_multifactor_authentication                 = activation_rules.value.require_multifactor_authentication
      require_ticket_info                                = activation_rules.value.require_ticket_info
      required_conditional_access_authentication_context = activation_rules.value.required_conditional_access_authentication_context

      dynamic "approval_stage" {
        for_each = activation_rules.value.approval_stage != null ? [activation_rules.value.approval_stage] : []
        content {
          dynamic "primary_approver" {
            for_each = {
              for idx, approver in coalesce(approval_stage.value.primary_approver, []) :
              format("%s-primary-%02d", each.key, idx) => approver
            }
            content {
              object_id = coalesce(
                primary_approver.value.object_id,
                try(data.azuread_group.primary_approver[primary_approver.key].object_id, null)
              )
              type = primary_approver.value.type
            }
          }
        }
      }
    }
  }

  dynamic "notification_rules" {
    for_each = each.value.role_management_policy.notification_rules != null ? [each.value.role_management_policy.notification_rules] : []
    content {
      dynamic "active_assignments" {
        for_each = notification_rules.value.active_assignments != null ? [notification_rules.value.active_assignments] : []
        content {
          dynamic "admin_notifications" {
            for_each = active_assignments.value.admin_notifications != null ? { default = active_assignments.value.admin_notifications } : {}
            content {
              notification_level    = admin_notifications.value.notification_level
              default_recipients    = admin_notifications.value.default_recipients
              additional_recipients = admin_notifications.value.additional_recipients
            }
          }

          dynamic "approver_notifications" {
            for_each = active_assignments.value.approver_notifications != null ? { default = active_assignments.value.approver_notifications } : {}
            content {
              notification_level    = approver_notifications.value.notification_level
              default_recipients    = approver_notifications.value.default_recipients
              additional_recipients = approver_notifications.value.additional_recipients
            }
          }

          dynamic "assignee_notifications" {
            for_each = active_assignments.value.assignee_notifications != null ? { default = active_assignments.value.assignee_notifications } : {}
            content {
              notification_level    = assignee_notifications.value.notification_level
              default_recipients    = assignee_notifications.value.default_recipients
              additional_recipients = assignee_notifications.value.additional_recipients
            }
          }
        }
      }

      dynamic "eligible_assignments" {
        for_each = notification_rules.value.eligible_assignments != null ? [notification_rules.value.eligible_assignments] : []
        content {
          dynamic "admin_notifications" {
            for_each = eligible_assignments.value.admin_notifications != null ? { default = eligible_assignments.value.admin_notifications } : {}
            content {
              notification_level    = admin_notifications.value.notification_level
              default_recipients    = admin_notifications.value.default_recipients
              additional_recipients = admin_notifications.value.additional_recipients
            }
          }

          dynamic "approver_notifications" {
            for_each = eligible_assignments.value.approver_notifications != null ? { default = eligible_assignments.value.approver_notifications } : {}
            content {
              notification_level    = approver_notifications.value.notification_level
              default_recipients    = approver_notifications.value.default_recipients
              additional_recipients = approver_notifications.value.additional_recipients
            }
          }

          dynamic "assignee_notifications" {
            for_each = eligible_assignments.value.assignee_notifications != null ? { default = eligible_assignments.value.assignee_notifications } : {}
            content {
              notification_level    = assignee_notifications.value.notification_level
              default_recipients    = assignee_notifications.value.default_recipients
              additional_recipients = assignee_notifications.value.additional_recipients
            }
          }
        }
      }

      dynamic "eligible_activations" {
        for_each = notification_rules.value.eligible_activations != null ? [notification_rules.value.eligible_activations] : []
        content {
          dynamic "admin_notifications" {
            for_each = eligible_activations.value.admin_notifications != null ? { default = eligible_activations.value.admin_notifications } : {}
            content {
              notification_level    = admin_notifications.value.notification_level
              default_recipients    = admin_notifications.value.default_recipients
              additional_recipients = admin_notifications.value.additional_recipients
            }
          }

          dynamic "approver_notifications" {
            for_each = eligible_activations.value.approver_notifications != null ? { default = eligible_activations.value.approver_notifications } : {}
            content {
              notification_level    = approver_notifications.value.notification_level
              default_recipients    = approver_notifications.value.default_recipients
              additional_recipients = approver_notifications.value.additional_recipients
            }
          }

          dynamic "assignee_notifications" {
            for_each = eligible_activations.value.assignee_notifications != null ? { default = eligible_activations.value.assignee_notifications } : {}
            content {
              notification_level    = assignee_notifications.value.notification_level
              default_recipients    = assignee_notifications.value.default_recipients
              additional_recipients = assignee_notifications.value.additional_recipients
            }
          }
        }
      }
    }
  }

  depends_on = [azurerm_role_definition.custom]
}

resource "azurerm_pim_eligible_role_assignment" "role" {
  for_each = {
    for k, v in local.assignments : k => v
    if v.pim_eligible != null
  }

  principal_id = element(compact([
    each.value.pim_eligible.principal_id,
    each.value.type == "Group" && each.value.display_name != null ? data.azuread_group.group[each.key].object_id : null,
    each.value.type == "User" && each.value.upn != null ? data.azuread_user.user[each.key].object_id : null,
    contains(["ServicePrincipal", "Application"], each.value.type) && each.value.display_name != null ? data.azuread_service_principal.sp[each.key].object_id : null,
    each.value.object_id
  ]), 0)

  scope              = each.value.scope
  role_definition_id = each.value.existing_role_definition ? data.azurerm_role_definition.custom[each.value.role].role_definition_id : contains(keys(var.role_definitions), each.value.role) ? azurerm_role_definition.custom[each.value.role].role_definition_id : data.azurerm_role_definition.builtin[each.key].role_definition_id
  justification      = each.value.pim_eligible.justification
  condition          = each.value.pim_eligible.condition
  condition_version  = each.value.pim_eligible.condition_version

  dynamic "schedule" {
    for_each = each.value.pim_eligible.schedule != null ? [each.value.pim_eligible.schedule] : []
    content {
      start_date_time = schedule.value.start_date_time

      dynamic "expiration" {
        for_each = schedule.value.expiration != null ? [schedule.value.expiration] : []
        content {
          duration_days  = expiration.value.duration_days
          duration_hours = expiration.value.duration_hours
          end_date_time  = expiration.value.end_date_time
        }
      }
    }
  }

  dynamic "ticket" {
    for_each = each.value.pim_eligible.ticket != null ? [each.value.pim_eligible.ticket] : []
    content {
      number = ticket.value.number
      system = ticket.value.system
    }
  }

  depends_on = [azurerm_role_management_policy.role, azurerm_role_definition.custom]
}

resource "azurerm_role_definition" "custom" {
  for_each = var.role_definitions

  name               = coalesce(each.value.role, each.key)
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
