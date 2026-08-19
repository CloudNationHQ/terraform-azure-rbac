locals {
  role_assignments = {
    john_doe = {
      object_id = azuread_user.this.object_id
      type      = "User"
      roles = {
        "Key Vault Secrets User" = {
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
        "Key Vault Reader" = {
          scopes = {
            kv = { id = module.kv.vault.id }
          }
        }
      }
    }
  }
}
