## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | ~> 1.25 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_postgresql"></a> [postgresql](#provider\_postgresql) | ~> 1.25 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.4 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.13 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [postgresql_database.this](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/database) | resource |
| [postgresql_default_privileges.user_func_def_priv](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.user_ro_tab_def_priv](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.user_seq_def_priv](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.user_tab_def_priv](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.user_types_def_priv](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_grant.user_all_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.user_all_schema](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.user_connect](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.user_func_def_priv](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.user_ro_tab_def_priv](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.user_seq_def_priv](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.user_tab_def_priv](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.user_usage_schema](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant_role.provided_owner](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant_role) | resource |
| [postgresql_role.owner](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [postgresql_role.role](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [postgresql_role.user](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [postgresql_schema.database_schema](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/schema) | resource |
| [random_password.owner](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.owner_initial](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.user_initial](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_rotating.owner](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [time_rotating.user](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_databases"></a> [databases](#input\_databases) | Map of PostgreSQL databases to create and manage. See inline docs for full schema. | `any` | `{}` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_force_reset"></a> [force\_reset](#input\_force\_reset) | (Optional) Force password reset for all managed roles on next apply. Default: false. | `bool` | `false` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_password_rotation_period"></a> [password\_rotation\_period](#input\_password\_rotation\_period) | (Optional) Password rotation period in days. 0 disables time-based rotation. Default: 0. | `number` | `0` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Map of PostgreSQL non-login group roles. See inline docs for full schema. | `any` | `{}` | no |
| <a name="input_rotated_owner_passwords"></a> [rotated\_owner\_passwords](#input\_rotated\_owner\_passwords) | (Optional) Map of db\_ref → current password from Lambda rotator. Required when rotation\_lambda\_name is set and force\_reset=false. | `map(string)` | `{}` | no |
| <a name="input_rotated_user_passwords"></a> [rotated\_user\_passwords](#input\_rotated\_user\_passwords) | (Optional) Map of user\_ref → current password from Lambda rotator. Required when rotation\_lambda\_name is set and force\_reset=false. | `map(string)` | `{}` | no |
| <a name="input_rotation_lambda_name"></a> [rotation\_lambda\_name](#input\_rotation\_lambda\_name) | (Optional) Name of the Lambda function managing password rotation. When set, random\_password is used only for initial seeding. Default: empty (use random\_password with time\_rotating). | `string` | `""` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_users"></a> [users](#input\_users) | Map of PostgreSQL login roles. See inline docs for full schema. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_databases"></a> [databases](#output\_databases) | Map of db\_ref → { name } for all managed databases. |
| <a name="output_owner_passwords"></a> [owner\_passwords](#output\_owner\_passwords) | Map of db\_ref → resolved owner password (sensitive). Consumed by cloud modules to write secrets. |
| <a name="output_owner_usernames"></a> [owner\_usernames](#output\_owner\_usernames) | Map of db\_ref → generated owner role name (e.g. 'mydb\_ow'). |
| <a name="output_user_passwords"></a> [user\_passwords](#output\_user\_passwords) | Map of user\_ref → resolved user password (sensitive). Consumed by cloud modules to write secrets. |
| <a name="output_user_usernames"></a> [user\_usernames](#output\_user\_usernames) | Map of user\_ref → PostgreSQL role name. |
| <a name="output_users"></a> [users](#output\_users) | Map of user\_ref → { name, grant } for all managed users. |
