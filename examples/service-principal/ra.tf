locals {
  role_assignments = {
    "TerraformDeploy" = {
      display_name = "TerraformDeploy"
      type         = "ServicePrincipal"
      roles = {
        "Key Vault Secrets User" = {
          scopes = {
            rg = { id = module.rg.groups.main.id }
          }
        }
        "Reader" = {
          scopes = {
            rg = { id = module.rg.groups.main.id }
            sa = { id = module.storage.account.id }
          }
        }
        "Storage Blob Data Contributor" = {
          scopes = {
            sa = { id = module.storage.account.id }
          }
        }
      }
    }
  }
}
