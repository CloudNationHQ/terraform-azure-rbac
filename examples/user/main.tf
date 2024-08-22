module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.2"

  groups = {
    main = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 1.0"

  storage = {
    name           = module.naming.storage_account.name
    location       = module.rg.groups.main.location
    resource_group = module.rg.groups.main.name
  }
}

module "rbac" {
  source  = "cloudnationhq/rbac/azure"
  version = "~> 0.1"

  role_assignments = local.role_assignments
}
