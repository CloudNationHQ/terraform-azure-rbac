locals {
  ### Index (key) is a combination of the display name, role and scope
  ### Replace the index of the display name and role with a dash, as whitespaces are not best practices for indexes within the state file
  role_assignments_flattened = flatten(
    [for key_ra, ra in var.role_assignments :
      [for key_role, role in ra.roles :
        [for key_scope, scope in role.scopes :
          {
            key          = "${replace(key_ra, " ", "-")}-${replace(key_role, " ", "-")}-${key_scope}"
            display_name = try(ra.display_name, null)
            object_id    = try(ra.object_id, null)
            upn          = ra.type == "User" ? ra.upn : null
            type         = ra.type
            role         = key_role
            scope        = scope
          }
  ]]])
}
