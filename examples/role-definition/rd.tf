locals {
  role_definitions = {
    "Custom Role 1" = {
      name = "Custom Role 1"
      permissions = {
        actions      = ["Microsoft.KeyVault/vaults/read"]
        data_actions = ["Microsoft.KeyVault/vaults/secrets/read"]
      }
      assignable_scopes = [module.rg.groups.main.id]
      scope             = module.rg.groups.main.id
    }
  }
}
