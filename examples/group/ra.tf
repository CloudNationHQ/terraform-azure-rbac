locals {
  role_assignments = {
    "Development" = {
      display_name = "Development"
      type         = "Group"
      roles = {
        "Key Vault Secrets User" = {
          scopes = {
            rg-main = { id = module.rg.groups.main.id }
          }
        }
        "Reader" = {
          scopes = {
            rg-main      = { id = module.rg.groups.main.id }
            storage-main = { id = module.storage.account.id }
          }
        }
        "Storage Blob Data Contributor" = {
          scopes = {
            storage-main = { id = module.storage.account.id }
          }
        }
      }
    }
  }
}
