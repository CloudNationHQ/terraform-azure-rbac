locals {
  role_assignments = {
    "john doe" = {
      upn  = "john.doe@contoso.onmicrosoft.com"
      type = "User"
      roles = {
        "Contributor" = {
          scopes = {
            rg-main = {
              id = module.rg.groups.main.id
              role_management_policy = {
                active_assignment_rules = {
                  expire_after = "P90D"
                }
                eligible_assignment_rules = {
                  expiration_required = false
                }
                activation_rules = {
                  maximum_duration = "PT1H"
                  require_approval = true
                  approval_stage = {
                    primary_approver = [
                      {
                        display_name = "Approvers"
                        type         = "Group"
                      }
                    ]
                  }
                }
                notification_rules = {
                  eligible_assignments = {
                    approver_notifications = {
                      notification_level    = "Critical"
                      default_recipients    = false
                      additional_recipients = ["someone@example.com"]
                    }
                  }
                  eligible_activations = {
                    assignee_notifications = {
                      notification_level    = "All"
                      default_recipients    = true
                      additional_recipients = ["someone.else@example.com"]
                    }
                  }
                }
              }
              pim_eligible = {
                justification = "Enable PIM eligible contributor access"
                schedule = {
                  expiration = {
                    duration_hours = 8
                  }
                }
                ticket = {
                  number = "1"
                  system = "example ticket system"
                }
              }
            }
          }
        }
      }
    }
  }
}
