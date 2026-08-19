locals {
  role_assignments = {
    john_doe = {
      object_id = module.users.users["john_doe"].object_id
      type      = "User"
      roles = {
        "Custom Role 1" = {
          description = "This is an assignment for a custom role in the role_definitions map"
          scopes = {
            rg = { id = module.rg.groups.main.id }
          }
        }
        "Contributor" = {
          description              = "This is an assignment for an existing built-in role definition"
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
