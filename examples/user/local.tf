locals {
  role_assignments = {
    "eddyvera" = {
      upn  = "eddy.vera@eddytenant.onmicrosoft.com"
      type = "User"
      roles = {
        "Key Vault Secrets User" = {
          scopes = {
            rg-main = module.rg.groups.main.id
          }
        }
        "Reader" = {
          scopes = {
            rg-main      = module.rg.groups.main.id
            storage-main = module.storage.account.id
          }
        }
        "Storage Blob Data Contributor" = {
          scopes = {
            storage-main = module.storage.account.id
          }
        }
      }
    }
  }
}
