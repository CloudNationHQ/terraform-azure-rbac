locals {
  role_assignments = {
    "john doe" = {
      upn  = "john.doe@contoso.onmicrosoft.com"
      type = "User"
      roles = {
        "Custom Role 1" = {
          description = "This is an assignment for a custom role in the role_definitions map"
          scopes = {
            rg-main = module.rg.groups.main.id
          }
        }
        "Custom Role 2" = {
          description              = "This is an assignment for a custom role that exists"
          existing_role_definition = true
          scopes = {
            storage-main = module.storage.account.id
          }
        }
        "Reader" = {
          scopes = {
            rg-main      = module.rg.groups.main.id
            storage-main = module.storage.account.id
          }
        }
      }
    }
  }
}
