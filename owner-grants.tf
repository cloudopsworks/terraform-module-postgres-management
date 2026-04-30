##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  admin_role = {
    for key, user in var.users : key => {
      name = user.name
      admin_role = try(user.db_ref, "") != "" ? (
        try(var.databases[user.db_ref].create_owner, false) ? local.owner_role_names[user.db_ref] :
        try(var.databases[user.db_ref].owner, "")
      ) : try(user.database_owner, "")
    }
  }
}

resource "postgresql_grant" "user_all_db" {
  for_each = {
    for key, user in var.users : key => user if try(user.grant, "") == "owner"
  }
  database    = try(each.value.db_ref, "") != "" ? postgresql_database.this[each.value.db_ref].name : each.value.database_name
  role        = local.user_role_names[each.key]
  object_type = "database"
  privileges  = ["ALL"]
}

resource "postgresql_grant" "user_all_schema" {
  for_each = {
    for key, user in var.users : key => user if try(user.grant, "") == "owner"
  }
  database    = try(each.value.db_ref, "") != "" ? postgresql_database.this[each.value.db_ref].name : each.value.database_name
  role        = local.user_role_names[each.key]
  object_type = "schema"
  schema      = try(each.value.schema, "public")
  privileges  = ["ALL"]
  depends_on  = [postgresql_database.this, postgresql_schema.database_schema]
}
