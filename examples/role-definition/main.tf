module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    main = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 6.0"

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.main.location
    resource_group_name = module.rg.groups.main.name
  }
}

data "azuread_domains" "this" {
  only_initial = true
}

module "users" {
  source  = "cloudnationhq/users/azuread"
  version = "~> 2.0"

  generate_password = true

  users = {
    jane_doe = {
      display_name        = "Jane Doe"
      user_principal_name = "jane.doe@${data.azuread_domains.this.domains[0].domain_name}"
    }
  }
}

locals {
  role_definitions = {
    "Custom Role 1" = {
      name = "Custom Role 1"
      permissions = {
        actions = ["Microsoft.KeyVault/vaults/read", "Microsoft.KeyVault/vaults/secrets/read"]
      }
      assignable_scopes = [module.rg.groups.main.id]
      scope             = module.rg.groups.main.id
    }
  }

  role_assignments = {
    jane_doe = {
      object_id = module.users.users["jane_doe"].object_id
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

module "rbac" {
  source  = "cloudnationhq/rbac/azure"
  version = "~> 4.0"

  role_assignments = local.role_assignments
  role_definitions = local.role_definitions
}
