##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "time_rotating" "user" {
  for_each = {
    for k, user in var.users : k => user if var.rotation_lambda_name == "" && var.password_rotation_period > 0
  }
  rotation_days = var.password_rotation_period
}

resource "random_password" "user" {
  for_each = {
    for k, user in var.users : k => user if var.rotation_lambda_name == ""
  }
  length           = 25
  special          = true
  override_special = "=_-+@~#"
  min_upper        = 2
  min_special      = 2
  min_numeric      = 2
  min_lower        = 2
  keepers = {
    force_reset = var.force_reset
  }
  lifecycle {
    replace_triggered_by = [
      time_rotating.user
    ]
  }
}

resource "random_password" "user_initial" {
  for_each = {
    for k, user in var.users : k => user if var.rotation_lambda_name != ""
  }
  length           = 25
  special          = true
  override_special = "=_-+@~#"
  min_upper        = 2
  min_special      = 2
  min_numeric      = 2
  min_lower        = 2
}

resource "postgresql_role" "user" {
  for_each = var.users
  name     = each.value.name
  password = var.rotation_lambda_name == "" ? random_password.user[each.key].result : (
    try(length(var.rotated_user_passwords[each.key]), 0) > 0 && !var.force_reset ?
    var.rotated_user_passwords[each.key] :
    random_password.user_initial[each.key].result
  )
  login              = try(each.value.login, true)
  superuser          = try(each.value.superuser, null)
  create_database    = try(each.value.create_database, null)
  replication        = try(each.value.replication, null)
  encrypted_password = try(each.value.encrypted_password, true)
  connection_limit   = try(each.value.connection_limit, -1)
  inherit            = try(each.value.inherit, null)
  create_role        = try(each.value.create_role, null)
  roles = try(each.value.grant, "") == "owner" ? (
    try(each.value.db_ref, "") != "" && try(var.databases[each.value.db_ref].create_owner, false) ?
    [postgresql_role.owner[each.value.db_ref].name] : []
  ) : []
}
