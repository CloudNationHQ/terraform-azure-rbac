variable "role_assignments" {
  description = "Contains all role assignment configuration"
  type = map(object({
    type                       = string
    display_name               = optional(string)
    upn                        = optional(string)
    object_id                  = optional(string)
    include_transitive_members = optional(bool, false)
    mail_enabled               = optional(bool)
    mail_nickname              = optional(string)
    security_enabled           = optional(bool)
    client_id                  = optional(string)
    mail                       = optional(string)
    employee_id                = optional(string)
    roles = map(object({
      existing_role_definition               = optional(bool, false)
      description                            = optional(string)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      scopes = map(object({
        id = optional(string)
        role_management_policy = optional(object({
          active_assignment_rules = optional(object({
            expiration_required                = optional(bool)
            expire_after                       = optional(string)
            require_justification              = optional(bool)
            require_multifactor_authentication = optional(bool)
            require_ticket_info                = optional(bool)
          }))
          eligible_assignment_rules = optional(object({
            expiration_required = optional(bool)
            expire_after        = optional(string)
          }))
          activation_rules = optional(object({
            maximum_duration                                   = optional(string)
            require_approval                                   = optional(bool)
            require_justification                              = optional(bool)
            require_multifactor_authentication                 = optional(bool)
            require_ticket_info                                = optional(bool)
            required_conditional_access_authentication_context = optional(string)
            approval_stage = optional(object({
              primary_approver = optional(list(object({
                object_id    = optional(string)
                type         = optional(string, "Group")
                display_name = optional(string)
              })))
            }))
          }))
          notification_rules = optional(object({
            active_assignments = optional(object({
              admin_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              approver_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              assignee_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
            }))
            eligible_assignments = optional(object({
              admin_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              approver_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              assignee_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
            }))
            eligible_activations = optional(object({
              admin_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              approver_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              assignee_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
            }))
          }))
        }))
        rmp = optional(object({
          active_assignment_rules = optional(object({
            expiration_required                = optional(bool)
            expire_after                       = optional(string)
            require_justification              = optional(bool)
            require_multifactor_authentication = optional(bool)
            require_ticket_info                = optional(bool)
          }))
          eligible_assignment_rules = optional(object({
            expiration_required = optional(bool)
            expire_after        = optional(string)
          }))
          activation_rules = optional(object({
            maximum_duration                                   = optional(string)
            require_approval                                   = optional(bool)
            require_justification                              = optional(bool)
            require_multifactor_authentication                 = optional(bool)
            require_ticket_info                                = optional(bool)
            required_conditional_access_authentication_context = optional(string)
            approval_stage = optional(object({
              primary_approver = optional(list(object({
                object_id    = optional(string)
                type         = optional(string, "Group")
                display_name = optional(string)
              })))
            }))
          }))
          notification_rules = optional(object({
            active_assignments = optional(object({
              admin_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              approver_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              assignee_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
            }))
            eligible_assignments = optional(object({
              admin_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              approver_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              assignee_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
            }))
            eligible_activations = optional(object({
              admin_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              approver_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
              assignee_notifications = optional(object({
                notification_level    = string
                default_recipients    = bool
                additional_recipients = optional(set(string))
              }))
            }))
          }))
        }))
        eligible = optional(object({
          principal_id      = optional(string)
          justification     = optional(string)
          condition         = optional(string)
          condition_version = optional(string)
          schedule = optional(object({
            start_date_time = optional(string)
            expiration = optional(object({
              duration_days  = optional(number)
              duration_hours = optional(number)
              end_date_time  = optional(string)
            }))
          }))
          ticket = optional(object({
            number = optional(string)
            system = optional(string)
          }))
        }))
        pim_eligible = optional(object({
          principal_id      = optional(string)
          justification     = optional(string)
          condition         = optional(string)
          condition_version = optional(string)
          schedule = optional(object({
            start_date_time = optional(string)
            expiration = optional(object({
              duration_days  = optional(number)
              duration_hours = optional(number)
              end_date_time  = optional(string)
            }))
          }))
          ticket = optional(object({
            number = optional(string)
            system = optional(string)
          }))
        }))
        pim = optional(object({
          principal_id      = optional(string)
          justification     = optional(string)
          condition         = optional(string)
          condition_version = optional(string)
          schedule = optional(object({
            start_date_time = optional(string)
            expiration = optional(object({
              duration_days  = optional(number)
              duration_hours = optional(number)
              end_date_time  = optional(string)
            }))
          }))
          ticket = optional(object({
            number = optional(string)
            system = optional(string)
          }))
        }))
      }))
    }))
  }))
}

variable "role_definitions" {
  description = "Contains all custom role definition configuration"
  type = map(object({
    role               = optional(string)
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
