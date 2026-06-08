variable "role_assignments" {
  description = "Contains all role assignment configuration"
  type = map(object({
    type                       = string
    display_name               = optional(string)
    upn                        = optional(string)
    object_id                  = optional(string)
    include_transitive_members = optional(bool)
    mail_enabled               = optional(bool)
    mail_nickname              = optional(string)
    security_enabled           = optional(bool)
    client_id                  = optional(string)
    mail                       = optional(string)
    employee_id                = optional(string)
    roles = map(object({
      existing_role_definition               = optional(bool, false)
      role_definition_id                     = optional(string)
      description                            = optional(string)
      skip_service_principal_aad_check       = optional(bool)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      scopes = map(object({
        id            = string
        assignment_id = optional(string)
      }))
    }))
  }))

  validation {
    condition = alltrue([
      for k, v in var.role_assignments :
      contains(["Group", "User", "ServicePrincipal", "Application"], v.type)
    ])
    error_message = "Each role assignment type must be one of: Group, User, ServicePrincipal, Application."
  }

  validation {
    condition = alltrue([
      for k, v in var.role_assignments :
      v.object_id != null || v.display_name != null || (v.type == "User" && v.upn != null)
    ])
    error_message = "Each role assignment must have at least one principal identifier: object_id, display_name (for Group/ServicePrincipal/Application), or upn (for User)."
  }
}

variable "role_definitions" {
  description = "Contains all custom role definition configuration"
  type = map(object({
    name               = optional(string)
    scope              = string
    role_definition_id = optional(string)
    description        = optional(string)
    assignable_scopes  = list(string)
    permissions = optional(object({
      actions          = optional(list(string))
      not_actions      = optional(list(string))
      data_actions     = optional(list(string))
      not_data_actions = optional(list(string))
    }))
  }))
  default = {}
}
