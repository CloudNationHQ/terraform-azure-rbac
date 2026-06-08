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
            scope                                  = scope.id
            assignment_id                          = scope.assignment_id
            existing_role_definition               = role.existing_role_definition
            role_definition_id                     = role.role_definition_id
            description                            = role.description
            skip_service_principal_aad_check       = role.skip_service_principal_aad_check
            condition                              = role.condition
            condition_version                      = role.condition_version
            delegated_managed_identity_resource_id = role.delegated_managed_identity_resource_id
          }
        ]
      ]
    ]) : assignment.key => assignment
  }
}
