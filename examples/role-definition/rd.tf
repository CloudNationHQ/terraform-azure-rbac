locals {
  role_definitions = {
    "Custom Role 1" = {
      name = "Custom Role 1"
      permissions = {
        actions      = ["Microsoft.Storage/storageAccounts/read"]
        data_actions = ["Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read"]
      }
      assignable_scopes = [module.rg.groups.main.id]
      scope             = module.rg.groups.main.id
    }
  }
}
