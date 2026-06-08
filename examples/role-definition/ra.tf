data "azuread_domains" "this" {
  only_initial = true
}

locals {
  role_assignments = {
    "john doe" = {
      upn  = "john.doe@${data.azuread_domains.this.domains[0].domain_name}"
      type = "User"
      roles = {
        "Custom Role 1" = {
          description = "This is an assignment for a custom role in the role_definitions map"
          scopes = {
            rg = { id = module.rg.groups.main.id }
          }
        }
        
        "Custom Role 2" = {
          description              = "This is an assignment for a custom role that exists"
          existing_role_definition = true
          scopes = {
            sa = { id = module.storage.account.id }
          }
        }
        "Reader" = {
          scopes = {
            rg      = { id = module.rg.groups.main.id }
            sa = { id = module.storage.account.id }
          }
        }
      }
    }
  }
}
