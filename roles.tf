##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

import {
  for_each = {
    for k, role in var.roles : k => role if try(role.import, false)
  }
  to = postgresql_role.role[each.key]
  id = each.value.name
}

resource "postgresql_role" "role" {
  for_each         = var.roles
  name             = each.value.name
  login            = false
  create_database  = try(each.value.create_database, null)
  replication      = try(each.value.replication, null)
  connection_limit = try(each.value.connection_limit, -1)
  inherit          = try(each.value.inherit, null)
  create_role      = try(each.value.create_role, null)
}
