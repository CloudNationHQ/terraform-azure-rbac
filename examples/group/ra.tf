locals {
  role_assignments = {
    development = {
      object_id = module.group.groups["development"].object_id
      type      = "Group"
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
