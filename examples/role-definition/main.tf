module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    main = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 4.0"

  storage = {
    name                = module.naming.storage_account.name_unique
    location            = module.rg.groups.main.location
    resource_group_name = module.rg.groups.main.name
  }
}

module "rbac" {
  source  = "cloudnationhq/rbac/azure"
  version = "~> 3.0"


  role_assignments = local.role_assignments
  role_definitions = local.role_definitions
}
