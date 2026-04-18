##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "owner_passwords" {
  description = "Map of db_ref → resolved owner password (sensitive). Consumed by cloud modules to write secrets."
  sensitive   = true
  value = {
    for key, db in var.databases : key => (
      var.rotation_lambda_name == "" ? random_password.owner[key].result :
      try(length(var.rotated_owner_passwords[key]), 0) > 0 && !var.force_reset ?
      var.rotated_owner_passwords[key] : random_password.owner_initial[key].result
    ) if try(db.create_owner, false)
  }
}

output "owner_usernames" {
  description = "Map of db_ref → generated owner role name (e.g. 'mydb_ow')."
  value       = local.owner_list
}

output "user_passwords" {
  description = "Map of user_ref → resolved user password (sensitive). Consumed by cloud modules to write secrets."
  sensitive   = true
  value = {
    for key, user in var.users : key => (
      var.rotation_lambda_name == "" ? random_password.user[key].result :
      try(length(var.rotated_user_passwords[key]), 0) > 0 && !var.force_reset ?
      var.rotated_user_passwords[key] : random_password.user_initial[key].result
    )
  }
}

output "user_usernames" {
  description = "Map of user_ref → PostgreSQL role name."
  value       = { for key, user in var.users : key => user.name }
}

output "databases" {
  description = "Map of db_ref → { name } for all managed databases."
  value       = { for key, db in postgresql_database.this : key => { name = db.name } }
}

output "users" {
  description = "Map of user_ref → { name, grant } for all managed users."
  value = {
    for key, user in var.users : key => {
      name  = user.name
      grant = try(user.grant, "")
    }
  }
}
