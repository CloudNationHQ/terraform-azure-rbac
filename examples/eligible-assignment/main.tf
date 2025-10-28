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

resource "time_static" "assignment_start" {}

module "rbac" {
  # source  = "cloudnationhq/rbac/azure"
  # version = "~> 2.0"
  source = "../../"

  role_assignments = local.role_assignments
}
