locals {
  role_assignments = {
    john_doe = {
      object_id = azuread_user.this.object_id
      type      = "User"
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
            kv = { id = module.kv.vault.id }
          }
        }
        "Reader" = {
          scopes = {
            rg = { id = module.rg.groups.main.id }
            kv = { id = module.kv.vault.id }
          }
        }
      }
    }
  }
}
