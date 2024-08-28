# Rbac

This terraform module simplifies the process of creating and managing role assignments on azure resources offering a flexible and powerful solution for managing azure role based access control (rbac) through code.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Non-Goals

These modules are not intended to be complete, ready-to-use solutions; they are designed as components for creating your own patterns.

They are not tailored for a single use case but are meant to be versatile and applicable to a range of scenarios.

Security standardization is applied at the pattern level, while the modules include default values based on best practices but do not enforce specific security standards.

End-to-end testing is not conducted on these modules, as they are individual components and do not undergo the extensive testing reserved for complete patterns or solutions.

## Features

- offers support for creating role assignment (role based access control) on Azure resources.
- support for creating new custom role definitions
- multiple roles and scopes can be defined per principal type.
- data lookup of group or service-principal (app registration) based on display name in Entra ID.
- data lookup of user based on upn in Entra ID.
- data lookup for existing custom role definitions and assigning these.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.95 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.47 |
| <a name="requirement_api_permissions"></a> [Entra ID api permissions](#requirement\_api_permissions_) | Directory.Read.All or Group.Read.All, Application.Read.All and User.Read.All  |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.95 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.47 |

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) | data source |
| [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `role_assignments` | contains all the role assignments configuration | object | yes |
| `role_definitions` | contains all the role definitions configuration for custom roles | object | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `role_assignments` | role assignment details |
| `role_definitions` | (custom) role definitions details |

## Testing

As a prerequirement, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) includes two distinct variations of tests. The first one is designed to deploy different usage scenarios of the module. These tests are executed by specifying the TF_PATH environment variable, which determines the different usages located in the example directory.

To execute this test, input the command ```make test TF_PATH=default```, substituting default with the specific usage you wish to test.

The second variation is known as a extended test. This one performs additional checks and can be executed without specifying any parameters, using the command ```make test_extended```.

Both are designed to be executed locally and are also integrated into the github workflow.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Notes

This module does not create or manages the actual user, group or service-principal in Entra ID.
It looks up the object ID of the service principal type based on display_name (servicePrincipal, application or Group type) or UPN (User type).
To lookup these values in Entra ID, specific API permissions are needed for the SP running Terraform, see also requirements.
If these API permissions cannot be granted for whatever reason, alternatively the object_id can be directly used instead.

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-rbac/graphs/contributors).

## Contributing

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/role-based-access-control/)
- [Rest Api](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-rest)
- [Rest Api Specs](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/role-based-access-control/role-assignments-list-rest.md)
