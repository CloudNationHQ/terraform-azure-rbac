data "azuread_domains" "this" {
  only_initial = true
}

locals {
  role_assignments = {
    "john doe" = {
      upn  = "john.doe@${data.azuread_domains.this.domains[0].domain_name}"
      type = "User"
      roles = {
        "Key Vault Secrets User" = {
          scopes = {
            rg = { id = module.rg.groups.main.id }
          }
        }
        "Reader" = {
          scopes = {
            rg      = { id = module.rg.groups.main.id }
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
