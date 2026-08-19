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

module "app" {
  source  = "cloudnationhq/app/azuread"
  version = "~> 1.0"

  registration = {
    display_name = "app-demo-dev"

    service_principal = {}
  }
}

module "rbac" {
  source  = "cloudnationhq/rbac/azure"
  version = "~> 4.0"

  role_assignments = local.role_assignments
}
