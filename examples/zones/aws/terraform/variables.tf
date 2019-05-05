/* Labeling */

variable "taito_organization" {
  type = "string"
}
variable "taito_zone" {
  type = "string"
}

/* Cloud provider */

variable "taito_provider" {
  type = "string"
}
variable "taito_provider_org_id" {
  type = "string"
}
variable "taito_provider_billing_account_id" {
  type = "string"
  default = ""
}
variable "taito_provider_user_profile" {
  type = "string"
  default = ""
}
variable "taito_provider_project_id" {
  type = "string"
}
variable "taito_provider_region" {
  type = "string"
}
variable "taito_provider_zone" {
  type = "string"
}
variable "taito_provider_additional_zones" {
  type = "list"
  default = []
}

/* User rights */

variable "taito_zone_owners" {
  type = "list"
  default = []
}
variable "taito_zone_editors" {
  type = "list"
  default = []
}
variable "taito_zone_viewers" {
  type = "list"
  default = []
}
variable "taito_zone_developers" {
  type = "list"
  default = []
}
variable "taito_zone_externals" {
  type = "list"
  default = []
}

/* Settings */

variable "taito_zone_devops_email" {
  type = "string"
}
variable "taito_zone_backup_day_limit" {
  type = "string" /* number */
}
variable "taito_zone_initial_database_password" {
  type = "string"
}
variable "taito_zone_authorized_network" {
  type = "string"
  default = "false"
}

/* Buckets */

variable "taito_zone_state_bucket" {
  type = "string"
  default = ""
}
variable "taito_zone_functions_bucket" {
  type = "string"
  default = ""
}
variable "taito_zone_backups_bucket" {
  type = "string"
  default = ""
}

/* Messaging */
/* NOTE: not required on Terraform */

/* Kubernetes */
/* NOTE: kubernetes_cluster and kubernetes_user not required on Terraform */

variable "kubernetes_name" {
  type = "string"
  default = ""
}
variable "kubernetes_version" {
  type = "string"
  default = ""
}
variable "kubernetes_machine_type" {
  type = "string"
  default = "n1-standard-1"
}
variable "kubernetes_disk_size_gb" {
  type = "string" /* number */
  default = "100"
}
variable "kubernetes_min_node_count" {
  type = "string" /* number */
  default = 1
}
variable "kubernetes_max_node_count" {
  type = "string" /* number */
  default = 1
}

/* Helm */

variable "helm_releases" {
  type = "list"
  default = []
}

variable "helm_nginx_ingress_replica_count" {
  type = "string"
  default = "1"
}

/* Postgres clusters */

variable "postgres_instances" {
  type = "list"
  default = []
}

variable "postgres_tiers" {
  type = "list"
  default = []
}

variable "postgres_sizes" {
  type = "list"
  default = []
}

variable "postgres_admins" {
  type = "list"
  default = []
}

/* MySQL clusters */

variable "mysql_instances" {
  type = "list"
  default = []
}

variable "mysql_tiers" {
  type = "list"
  default = []
}

variable "mysql_sizes" {
  type = "list"
  default = []
}

variable "mysql_admins" {
  type = "list"
  default = []
}

/* Logging */

variable "logging_sinks" {
  type = "list"
  default = []
}

variable "logging_companies" {
  type = "list"
  default = []
}

/* Temporary AWS / Kubernetes specific settings */

# EXAMPLE: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/eks_test_fixture/variables.tf

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = "list"

  default = [
    /*
    "777777777777",
    "888888888888",
    */
  ]
}

variable "map_accounts_count" {
  description = "The count of accounts in the map_accounts list."
  type        = "string"
  default     = 0
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type        = "list"

  default = [
    /*
    {
      role_arn = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      group    = "system:masters"
    },
    */
  ]
}

variable "map_roles_count" {
  description = "The count of roles in the map_roles list."
  type        = "string"
  default     = 0
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"

  default = [
    /*
    {
      user_arn = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      group    = "system:masters"
    },
    */
  ]
}

variable "map_users_count" {
  description = "The count of roles in the map_users list."
  type        = "string"
  default     = 0
}
