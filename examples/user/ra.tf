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
