data "azuread_group" "group" {
  for_each = {
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = try(principal.display_name, null)
            include_transitive_members             = try(principal.include_transitive_members, false)
            mail_enabled                           = try(principal.mail_enabled, null)
            mail_nickname                          = try(principal.mail_nickname, null)
            security_enabled                       = try(principal.security_enabled, null)
            client_id                              = try(principal.client_id, null)
            object_id                              = lookup(principal, "object_id", null)
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = try(principal.mail, null)
            employee_id                            = try(principal.employee_id, null)
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = try(role.existing_role_definition, false)
            description                            = try(role.description, null)
            skip_service_principal_aad_check       = try(role.skip_service_principal_aad_check, false)
            condition                              = try(role.condition, null)
            condition_version                      = try(role.condition_version, null)
            delegated_managed_identity_resource_id = try(role.delegated_managed_identity_resource_id, null)
            role_management_policy                 = try(scope.role_management_policy, try(scope.rmp, null))
            pim_eligible                           = try(scope.eligible, try(scope.pim_eligible, try(scope.pim, null)))
          }
        ]
      ]
    ]) : assignment.key => assignment
    if assignment.type == "Group" && assignment.display_name != null
  }

  display_name               = each.value.display_name
  include_transitive_members = try(each.value.include_transitive_members, false)
  mail_enabled               = try(each.value.mail_enabled, null)
  mail_nickname              = try(each.value.mail_nickname, null)
  security_enabled           = try(each.value.security_enabled, null)
  object_id                  = try(each.value.object_id, null)
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
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = try(principal.display_name, null)
            include_transitive_members             = try(principal.include_transitive_members, false)
            mail_enabled                           = try(principal.mail_enabled, null)
            mail_nickname                          = try(principal.mail_nickname, null)
            security_enabled                       = try(principal.security_enabled, null)
            client_id                              = try(principal.client_id, null)
            object_id                              = lookup(principal, "object_id", null)
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = try(principal.mail, null)
            employee_id                            = try(principal.employee_id, null)
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = try(role.existing_role_definition, false)
            description                            = try(role.description, null)
            skip_service_principal_aad_check       = try(role.skip_service_principal_aad_check, false)
            condition                              = try(role.condition, null)
            condition_version                      = try(role.condition_version, null)
            delegated_managed_identity_resource_id = try(role.delegated_managed_identity_resource_id, null)
            role_management_policy                 = try(scope.role_management_policy, try(scope.rmp, null))
            pim_eligible                           = try(scope.eligible, try(scope.pim_eligible, try(scope.pim, null)))
          }
        ]
      ]
    ]) : assignment.key => assignment
    if(assignment.type == "ServicePrincipal" || assignment.type == "Application") && assignment.display_name != null
  }

  display_name = each.value.display_name
  client_id    = try(each.value.client_id, null)
  object_id    = try(each.value.object_id, null)
}

data "azuread_user" "user" {
  for_each = {
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = try(principal.display_name, null)
            include_transitive_members             = try(principal.include_transitive_members, false)
            mail_enabled                           = try(principal.mail_enabled, null)
            mail_nickname                          = try(principal.mail_nickname, null)
            security_enabled                       = try(principal.security_enabled, null)
            client_id                              = try(principal.client_id, null)
            object_id                              = lookup(principal, "object_id", null)
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = try(principal.mail, null)
            employee_id                            = try(principal.employee_id, null)
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = try(role.existing_role_definition, false)
            description                            = try(role.description, null)
            skip_service_principal_aad_check       = try(role.skip_service_principal_aad_check, false)
            condition                              = try(role.condition, null)
            condition_version                      = try(role.condition_version, null)
            delegated_managed_identity_resource_id = try(role.delegated_managed_identity_resource_id, null)
            role_management_policy                 = try(scope.role_management_policy, try(scope.rmp, null))
            pim_eligible                           = try(scope.eligible, try(scope.pim_eligible, try(scope.pim, null)))
          }
        ]
      ]
    ]) : assignment.key => assignment
    if assignment.type == "User" && assignment.upn != null
  }

  user_principal_name = each.value.upn
  object_id           = try(each.value.object_id, null)
  mail_nickname       = try(each.value.mail_nickname, null)
  mail                = try(each.value.mail, null)
  employee_id         = try(each.value.employee_id, null)
}

data "azurerm_role_definition" "custom" {
  for_each = {
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = try(principal.display_name, null)
            include_transitive_members             = try(principal.include_transitive_members, false)
            mail_enabled                           = try(principal.mail_enabled, null)
            mail_nickname                          = try(principal.mail_nickname, null)
            security_enabled                       = try(principal.security_enabled, null)
            client_id                              = try(principal.client_id, null)
            object_id                              = lookup(principal, "object_id", null)
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = try(principal.mail, null)
            employee_id                            = try(principal.employee_id, null)
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = try(role.existing_role_definition, false)
            description                            = try(role.description, null)
            skip_service_principal_aad_check       = try(role.skip_service_principal_aad_check, false)
            condition                              = try(role.condition, null)
            condition_version                      = try(role.condition_version, null)
            delegated_managed_identity_resource_id = try(role.delegated_managed_identity_resource_id, null)
            role_management_policy                 = try(scope.role_management_policy, try(scope.rmp, null))
            pim_eligible                           = try(scope.eligible, try(scope.pim_eligible, try(scope.pim, null)))
          }
        ]
      ]
    ]) : assignment.role => assignment
    if assignment.existing_role_definition == true
  }

  name               = each.value.role
  scope              = each.value.scope
  role_definition_id = try(each.value.role_definition_id, null)
}

data "azurerm_role_definition" "builtin" {
  for_each = {
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = try(principal.display_name, null)
            include_transitive_members             = try(principal.include_transitive_members, false)
            mail_enabled                           = try(principal.mail_enabled, null)
            mail_nickname                          = try(principal.mail_nickname, null)
            security_enabled                       = try(principal.security_enabled, null)
            client_id                              = try(principal.client_id, null)
            object_id                              = lookup(principal, "object_id", null)
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = try(principal.mail, null)
            employee_id                            = try(principal.employee_id, null)
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = try(role.existing_role_definition, false)
            description                            = try(role.description, null)
            skip_service_principal_aad_check       = try(role.skip_service_principal_aad_check, false)
            condition                              = try(role.condition, null)
            condition_version                      = try(role.condition_version, null)
            delegated_managed_identity_resource_id = try(role.delegated_managed_identity_resource_id, null)
            role_management_policy                 = try(scope.role_management_policy, try(scope.rmp, null))
            pim_eligible                           = try(scope.eligible, try(scope.pim_eligible, try(scope.pim, null)))
          }
        ]
      ]
    ]) : assignment.key => assignment
    if assignment.existing_role_definition == false && !contains(try(keys(var.role_definitions), []), assignment.role)
  }

  name  = each.value.role
  scope = each.value.scope
}

resource "azurerm_role_assignment" "role" {
  for_each = {
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = try(principal.display_name, null)
            include_transitive_members             = try(principal.include_transitive_members, false)
            mail_enabled                           = try(principal.mail_enabled, null)
            mail_nickname                          = try(principal.mail_nickname, null)
            security_enabled                       = try(principal.security_enabled, null)
            client_id                              = try(principal.client_id, null)
            object_id                              = lookup(principal, "object_id", null)
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = try(principal.mail, null)
            employee_id                            = try(principal.employee_id, null)
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = try(role.existing_role_definition, false)
            description                            = try(role.description, null)
            skip_service_principal_aad_check       = try(role.skip_service_principal_aad_check, false)
            condition                              = try(role.condition, null)
            condition_version                      = try(role.condition_version, null)
            delegated_managed_identity_resource_id = try(role.delegated_managed_identity_resource_id, null)
            role_management_policy                 = try(scope.role_management_policy, try(scope.rmp, null))
            pim_eligible                           = try(scope.eligible, try(scope.pim_eligible, try(scope.pim, null)))
          }
        ]
      ]
    ]) : assignment.key => assignment
    if(assignment.display_name != null || assignment.upn != null) && assignment.pim_eligible == null
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
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = try(principal.display_name, null)
            include_transitive_members             = try(principal.include_transitive_members, false)
            mail_enabled                           = try(principal.mail_enabled, null)
            mail_nickname                          = try(principal.mail_nickname, null)
            security_enabled                       = try(principal.security_enabled, null)
            client_id                              = try(principal.client_id, null)
            object_id                              = lookup(principal, "object_id", null)
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = try(principal.mail, null)
            employee_id                            = try(principal.employee_id, null)
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = try(role.existing_role_definition, false)
            description                            = try(role.description, null)
            skip_service_principal_aad_check       = try(role.skip_service_principal_aad_check, false)
            condition                              = try(role.condition, null)
            condition_version                      = try(role.condition_version, null)
            delegated_managed_identity_resource_id = try(role.delegated_managed_identity_resource_id, null)
            role_management_policy                 = try(scope.role_management_policy, try(scope.rmp, null))
            pim_eligible                           = try(scope.eligible, try(scope.pim_eligible, try(scope.pim, null)))
          }
        ]
      ]
    ]) : assignment.key => assignment
    if assignment.display_name == null && assignment.upn == null && assignment.pim_eligible == null
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

resource "azurerm_role_management_policy" "role" {
  for_each = {
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = try(principal.display_name, null)
            include_transitive_members             = try(principal.include_transitive_members, false)
            mail_enabled                           = try(principal.mail_enabled, null)
            mail_nickname                          = try(principal.mail_nickname, null)
            security_enabled                       = try(principal.security_enabled, null)
            client_id                              = try(principal.client_id, null)
            object_id                              = lookup(principal, "object_id", null)
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = try(principal.mail, null)
            employee_id                            = try(principal.employee_id, null)
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = try(role.existing_role_definition, false)
            description                            = try(role.description, null)
            skip_service_principal_aad_check       = try(role.skip_service_principal_aad_check, false)
            condition                              = try(role.condition, null)
            condition_version                      = try(role.condition_version, null)
            delegated_managed_identity_resource_id = try(role.delegated_managed_identity_resource_id, null)
            role_management_policy                 = try(scope.role_management_policy, try(scope.rmp, null))
            pim_eligible                           = try(scope.eligible, try(scope.pim_eligible, try(scope.pim, null)))
          }
        ]
      ]
    ]) : assignment.key => assignment
    if assignment.role_management_policy != null
  }

  scope              = each.value.scope
  role_definition_id = each.value.existing_role_definition == true ? data.azurerm_role_definition.custom[each.value.role].role_definition_id : contains(try(keys(var.role_definitions), []), each.value.role) ? azurerm_role_definition.custom[each.value.role].role_definition_id : data.azurerm_role_definition.builtin[each.key].role_definition_id

  dynamic "active_assignment_rules" {
    for_each = try(each.value.role_management_policy.active_assignment_rules, null) != null ? [each.value.role_management_policy.active_assignment_rules] : []
    content {
      expiration_required                = try(active_assignment_rules.value.expiration_required, null)
      expire_after                       = try(active_assignment_rules.value.expire_after, null)
      require_justification              = try(active_assignment_rules.value.require_justification, null)
      require_multifactor_authentication = try(active_assignment_rules.value.require_multifactor_authentication, null)
      require_ticket_info                = try(active_assignment_rules.value.require_ticket_info, null)
    }
  }

  dynamic "eligible_assignment_rules" {
    for_each = try(each.value.role_management_policy.eligible_assignment_rules, null) != null ? [each.value.role_management_policy.eligible_assignment_rules] : []
    content {
      expiration_required = try(eligible_assignment_rules.value.expiration_required, null)
      expire_after        = try(eligible_assignment_rules.value.expire_after, null)
    }
  }

  dynamic "activation_rules" {
    for_each = try(each.value.role_management_policy.activation_rules, null) != null ? [each.value.role_management_policy.activation_rules] : []
    content {
      maximum_duration                                   = try(activation_rules.value.maximum_duration, null)
      require_approval                                   = try(activation_rules.value.require_approval, null)
      require_justification                              = try(activation_rules.value.require_justification, null)
      require_multifactor_authentication                 = try(activation_rules.value.require_multifactor_authentication, null)
      require_ticket_info                                = try(activation_rules.value.require_ticket_info, null)
      required_conditional_access_authentication_context = try(activation_rules.value.required_conditional_access_authentication_context, null)

      dynamic "approval_stage" {
        for_each = try(activation_rules.value.approval_stage, null) != null ? [activation_rules.value.approval_stage] : []
        content {
          dynamic "primary_approver" {
            for_each = {
              for idx, approver in try(
                tolist(approval_stage.value.primary_approver),
                approval_stage.value.primary_approver == null ? [] : [approval_stage.value.primary_approver]
              ) :
              format("%s-primary-%02d", each.key, idx) => approver
            }
            content {
              object_id = coalesce(
                try(primary_approver.value.object_id, null),
                try(data.azuread_group.primary_approver[primary_approver.key].object_id, null)
              )
              type = try(primary_approver.value.type, "Group")
            }
          }
        }
      }
    }
  }

  dynamic "notification_rules" {
    for_each = try(each.value.role_management_policy.notification_rules, null) != null ? [each.value.role_management_policy.notification_rules] : []
    content {
      dynamic "active_assignments" {
        for_each = try(notification_rules.value.active_assignments, null) != null ? [notification_rules.value.active_assignments] : []
        content {
          dynamic "admin_notifications" {
            for_each = try(can(active_assignments.value.admin_notifications[0]) ? active_assignments.value.admin_notifications : [active_assignments.value.admin_notifications], [])
            content {
              notification_level    = admin_notifications.value.notification_level
              default_recipients    = admin_notifications.value.default_recipients
              additional_recipients = try(admin_notifications.value.additional_recipients, null)
            }
          }

          dynamic "approver_notifications" {
            for_each = try(can(active_assignments.value.approver_notifications[0]) ? active_assignments.value.approver_notifications : [active_assignments.value.approver_notifications], [])
            content {
              notification_level    = approver_notifications.value.notification_level
              default_recipients    = approver_notifications.value.default_recipients
              additional_recipients = try(approver_notifications.value.additional_recipients, null)
            }
          }

          dynamic "assignee_notifications" {
            for_each = try(can(active_assignments.value.assignee_notifications[0]) ? active_assignments.value.assignee_notifications : [active_assignments.value.assignee_notifications], [])
            content {
              notification_level    = assignee_notifications.value.notification_level
              default_recipients    = assignee_notifications.value.default_recipients
              additional_recipients = try(assignee_notifications.value.additional_recipients, null)
            }
          }
        }
      }

      dynamic "eligible_assignments" {
        for_each = try(notification_rules.value.eligible_assignments, null) != null ? [notification_rules.value.eligible_assignments] : []
        content {
          dynamic "admin_notifications" {
            for_each = try(can(eligible_assignments.value.admin_notifications[0]) ? eligible_assignments.value.admin_notifications : [eligible_assignments.value.admin_notifications], [])
            content {
              notification_level    = admin_notifications.value.notification_level
              default_recipients    = admin_notifications.value.default_recipients
              additional_recipients = try(admin_notifications.value.additional_recipients, null)
            }
          }

          dynamic "approver_notifications" {
            for_each = try(can(eligible_assignments.value.approver_notifications[0]) ? eligible_assignments.value.approver_notifications : [eligible_assignments.value.approver_notifications], [])
            content {
              notification_level    = approver_notifications.value.notification_level
              default_recipients    = approver_notifications.value.default_recipients
              additional_recipients = try(approver_notifications.value.additional_recipients, null)
            }
          }

          dynamic "assignee_notifications" {
            for_each = try(can(eligible_assignments.value.assignee_notifications[0]) ? eligible_assignments.value.assignee_notifications : [eligible_assignments.value.assignee_notifications], [])
            content {
              notification_level    = assignee_notifications.value.notification_level
              default_recipients    = assignee_notifications.value.default_recipients
              additional_recipients = try(assignee_notifications.value.additional_recipients, null)
            }
          }
        }
      }

      dynamic "eligible_activations" {
        for_each = try(notification_rules.value.eligible_activations, null) != null ? [notification_rules.value.eligible_activations] : []
        content {
          dynamic "admin_notifications" {
            for_each = try(can(eligible_activations.value.admin_notifications[0]) ? eligible_activations.value.admin_notifications : [eligible_activations.value.admin_notifications], [])
            content {
              notification_level    = admin_notifications.value.notification_level
              default_recipients    = admin_notifications.value.default_recipients
              additional_recipients = try(admin_notifications.value.additional_recipients, null)
            }
          }

          dynamic "approver_notifications" {
            for_each = try(can(eligible_activations.value.approver_notifications[0]) ? eligible_activations.value.approver_notifications : [eligible_activations.value.approver_notifications], [])
            content {
              notification_level    = approver_notifications.value.notification_level
              default_recipients    = approver_notifications.value.default_recipients
              additional_recipients = try(approver_notifications.value.additional_recipients, null)
            }
          }

          dynamic "assignee_notifications" {
            for_each = try(can(eligible_activations.value.assignee_notifications[0]) ? eligible_activations.value.assignee_notifications : [eligible_activations.value.assignee_notifications], [])
            content {
              notification_level    = assignee_notifications.value.notification_level
              default_recipients    = assignee_notifications.value.default_recipients
              additional_recipients = try(assignee_notifications.value.additional_recipients, null)
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
    for assignment in flatten([
      for principal_key, principal in var.role_assignments : [
        for role_key, role in principal.roles : [
          for scope_key, scope in role.scopes : {
            key                                    = "${replace(principal_key, " ", "-")}-${replace(role_key, " ", "-")}-${scope_key}"
            principal_key                          = principal_key
            type                                   = principal.type
            display_name                           = try(principal.display_name, null)
            include_transitive_members             = try(principal.include_transitive_members, false)
            mail_enabled                           = try(principal.mail_enabled, null)
            mail_nickname                          = try(principal.mail_nickname, null)
            security_enabled                       = try(principal.security_enabled, null)
            client_id                              = try(principal.client_id, null)
            object_id                              = lookup(principal, "object_id", null)
            upn                                    = principal.type == "User" ? principal.upn : null
            mail                                   = try(principal.mail, null)
            employee_id                            = try(principal.employee_id, null)
            role                                   = role_key
            scope_key                              = scope_key
            scope                                  = try(scope.id, scope)
            existing_role_definition               = try(role.existing_role_definition, false)
            description                            = try(role.description, null)
            skip_service_principal_aad_check       = try(role.skip_service_principal_aad_check, false)
            condition                              = try(role.condition, null)
            condition_version                      = try(role.condition_version, null)
            delegated_managed_identity_resource_id = try(role.delegated_managed_identity_resource_id, null)
            role_management_policy                 = try(scope.role_management_policy, try(scope.rmp, null))
            pim_eligible                           = try(scope.eligible, try(scope.pim_eligible, try(scope.pim, null)))
          }
        ]
      ]
    ]) : assignment.key => assignment
    if assignment.pim_eligible != null
  }

  scope              = each.value.scope
  role_definition_id = each.value.existing_role_definition == true ? data.azurerm_role_definition.custom[each.value.role].role_definition_id : contains(try(keys(var.role_definitions), []), each.value.role) ? azurerm_role_definition.custom[each.value.role].role_definition_id : data.azurerm_role_definition.builtin[each.key].role_definition_id
  principal_id = element(compact([
    try(each.value.pim_eligible.principal_id, null),
    each.value.type == "Group" && each.value.display_name != null ? data.azuread_group.group[each.key].object_id : null,
    each.value.type == "User" && each.value.upn != null ? data.azuread_user.user[each.key].object_id : null,
    contains(["ServicePrincipal", "Application"], each.value.type) && each.value.display_name != null ? data.azuread_service_principal.sp[each.key].object_id : null,
    each.value.object_id
  ]), 0)
  justification     = try(each.value.pim_eligible.justification, null)
  condition         = try(each.value.pim_eligible.condition, null)
  condition_version = try(each.value.pim_eligible.condition_version, null)

  dynamic "schedule" {
    for_each = try(each.value.pim_eligible.schedule, null) != null ? [each.value.pim_eligible.schedule] : []
    content {
      start_date_time = try(schedule.value.start_date_time, null)

      dynamic "expiration" {
        for_each = try(schedule.value.expiration, null) != null ? [schedule.value.expiration] : []
        content {
          duration_days  = try(expiration.value.duration_days, null)
          duration_hours = try(expiration.value.duration_hours, null)
          end_date_time  = try(expiration.value.end_date_time, null)
        }
      }
    }
  }

  dynamic "ticket" {
    for_each = try(each.value.pim_eligible.ticket, null) != null ? [each.value.pim_eligible.ticket] : []
    content {
      number = try(ticket.value.number, null)
      system = try(ticket.value.system, null)
    }
  }

  depends_on = [azurerm_role_management_policy.role, azurerm_role_definition.custom]
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
