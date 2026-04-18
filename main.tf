##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  owner_list = {
    for key, db in var.databases : key => "${db.name}_ow" if try(db.create_owner, false)
  }
}

import {
  for_each = {
    for k, db in var.databases : k => db if try(db.import, false)
  }
  to = postgresql_database.this[each.key]
  id = each.value.name
}

resource "postgresql_database" "this" {
  depends_on             = [postgresql_role.owner]
  for_each               = var.databases
  name                   = each.value.name
  owner                  = try(each.value.create_owner, false) ? local.owner_list[each.key] : try(each.value.owner, null)
  lc_collate             = try(each.value.collate, null)
  lc_ctype               = try(each.value.ctype, null)
  connection_limit       = try(each.value.connection_limit, -1)
  is_template            = try(each.value.is_template, null)
  template               = try(each.value.template, null)
  encoding               = try(each.value.encoding, null)
  allow_connections      = try(each.value.allow_connections, null)
  alter_object_ownership = try(each.value.alter_object_ownership, null)
}

resource "time_rotating" "owner" {
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false) && var.rotation_lambda_name == "" && var.password_rotation_period > 0
  }
  rotation_days = var.password_rotation_period
}

resource "random_password" "owner" {
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false) && var.rotation_lambda_name == ""
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
      time_rotating.owner
    ]
  }
}

resource "random_password" "owner_initial" {
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false) && var.rotation_lambda_name != ""
  }
  length           = 25
  special          = true
  override_special = "=_-+@~#"
  min_upper        = 2
  min_special      = 2
  min_numeric      = 2
  min_lower        = 2
}

import {
  for_each = {
    for k, db in var.databases : k => db if try(db.import, false) && try(db.create_owner, false)
  }
  to = postgresql_role.owner[each.key]
  id = local.owner_list[each.key]
}

resource "postgresql_role" "owner" {
  for_each = {
    for key, db in var.databases : key => db if try(db.create_owner, false)
  }
  name = local.owner_list[each.key]
  password = var.rotation_lambda_name == "" ? random_password.owner[each.key].result : (
    try(length(var.rotated_owner_passwords[each.key]), 0) > 0 && !var.force_reset ?
    var.rotated_owner_passwords[each.key] :
    random_password.owner_initial[each.key].result
  )
  encrypted_password = true
  create_role        = true
  login              = true
}

resource "postgresql_grant_role" "provided_owner" {
  depends_on = [postgresql_role.owner]
  for_each = {
    for key, db in var.databases : key => db if !try(db.create_owner, false) && try(db.owner, "") != ""
  }
  grant_role = each.value.owner
  role       = each.value.owner
}

resource "postgresql_schema" "database_schema" {
  for_each = merge([
    for key, db in var.databases : {
      for schema in try(db.schemas, []) : "${key}_${schema.name}" => {
        db_ref = key
        schema = schema
      }
    }
  ]...)
  name          = each.value.schema.name
  database      = postgresql_database.this[each.value.db_ref].name
  owner         = try(postgresql_role.owner[each.value.db_ref].name, try(each.value.schema.owner, null))
  if_not_exists = try(each.value.schema.reuse, true)
  drop_cascade  = try(each.value.schema.cascade_on_delete, false)
  depends_on = [
    postgresql_database.this,
    postgresql_role.owner,
  ]
}
