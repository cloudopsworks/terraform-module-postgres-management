##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## databases: map of database definitions
# databases:
#   <db_ref>:
#     name: "dbname"                    # (Required) Database name.
#     create_owner: false               # (Optional) Create a dedicated owner role. Default: false.
#     owner: "ownername"                # (Conditionally Required) Owner role name if create_owner=false.
#     collate: "en_US.UTF-8"            # (Optional) LC_COLLATE. Default: null (server default).
#     ctype: "en_US.UTF-8"              # (Optional) LC_CTYPE. Default: null.
#     connection_limit: -1              # (Optional) Max connections. Default: -1 (unlimited).
#     is_template: false                # (Optional) Template database. Default: null.
#     template: "template0"             # (Optional) Source template. Default: null.
#     encoding: "UTF8"                  # (Optional) Encoding. Default: null.
#     allow_connections: true           # (Optional) Allow connections. Default: null.
#     alter_object_ownership: false     # (Optional) Alter object ownership on create. Default: null.
#     import: false                     # (Optional) Import existing database instead of creating. Default: false.
#     schemas:                          # (Optional) Schemas to create inside this database.
#       - name: "app"                   # (Required) Schema name.
#         owner: "user_ref_or_rolename" # (Optional) Schema owner. Default: database owner.
#         reuse: true                   # (Optional) Skip error if schema exists. Default: true.
#         cascade_on_delete: false      # (Optional) DROP CASCADE on destroy. Default: false.
variable "databases" {
  description = "Map of PostgreSQL databases to create and manage. See inline docs for full schema."
  type        = any
  default     = {}
}

## users: map of login roles
# users:
#   <user_ref>:
#     name: "username"                  # (Required) PostgreSQL role name.
#     grant: "readwrite"                # (Required) Grant type: owner | readwrite | readonly.
#     db_ref: "db_ref"                  # (Optional) Key into var.databases for database association.
#     database_name: "dbname"           # (Optional) Explicit database name when db_ref not set.
#     database_owner: "ownername"       # (Conditionally Required) Owner role to inherit when grant=owner and no db_ref.
#     schema: "public"                  # (Optional) Schema for grants. Default: "public".
#     login: true                       # (Optional) Allow login. Default: true.
#     superuser: false                  # (Optional) Superuser. Default: null.
#     create_database: false            # (Optional) CREATEDB. Default: null.
#     replication: false                # (Optional) Replication. Default: null.
#     encrypted_password: true          # (Optional) Encrypt password. Default: true.
#     inherit: true                     # (Optional) Inherit from parent roles. Default: null.
#     create_role: false                # (Optional) CREATEROLE. Default: null.
#     connection_limit: -1              # (Optional) Max connections. Default: -1.
#     import: false                     # (Optional) Import existing role. Default: false.
variable "users" {
  description = "Map of PostgreSQL login roles. See inline docs for full schema."
  type        = any
  default     = {}
}

## roles: map of non-login group roles
# roles:
#   <role_ref>:
#     name: "rolename"                  # (Required) Role name.
#     grant: "owner"                    # (Optional) Grant context: owner | readwrite | readonly.
#     db_ref: "db_ref"                  # (Optional) Associated database ref.
#     database_name: "dbname"           # (Optional) Explicit database name.
#     schema: "public"                  # (Optional) Schema for grants.
#     create_database: false            # (Optional) CREATEDB. Default: null.
#     replication: false                # (Optional) Replication. Default: null.
#     inherit: true                     # (Optional) Inherit. Default: null.
#     create_role: false                # (Optional) CREATEROLE. Default: null.
#     connection_limit: -1              # (Optional) Connection limit. Default: -1.
#     import: false                     # (Optional) Import existing role. Default: false.
variable "roles" {
  description = "Map of PostgreSQL non-login group roles. See inline docs for full schema."
  type        = any
  default     = {}
}

## password_rotation_period: number of days between password rotations (0 = no rotation)
variable "password_rotation_period" {
  description = "(Optional) Password rotation period in days. 0 disables time-based rotation. Default: 0."
  type        = number
  default     = 0
}

## force_reset: force immediate password replacement on next apply
variable "force_reset" {
  description = "(Optional) Force password reset for all managed roles on next apply. Default: false."
  type        = bool
  default     = false
}

## rotation_lambda_name: when non-empty, passwords are managed externally by a Lambda rotator.
## The cloud module must supply current passwords via rotated_owner_passwords / rotated_user_passwords.
variable "rotation_lambda_name" {
  description = "(Optional) Name of the Lambda function managing password rotation. When set, random_password is used only for initial seeding. Default: empty (use random_password with time_rotating)."
  type        = string
  default     = ""
}

## rotated_owner_passwords: current owner passwords from Lambda rotation (keyed by db_ref).
## Only used when rotation_lambda_name is non-empty. Supplied by the cloud module.
variable "rotated_owner_passwords" {
  description = "(Optional) Map of db_ref → current password from Lambda rotator. Required when rotation_lambda_name is set and force_reset=false."
  type        = map(string)
  default     = {}
  sensitive   = true
}

## rotated_user_passwords: current user passwords from Lambda rotation (keyed by user_ref).
variable "rotated_user_passwords" {
  description = "(Optional) Map of user_ref → current password from Lambda rotator. Required when rotation_lambda_name is set and force_reset=false."
  type        = map(string)
  default     = {}
  sensitive   = true
}
