variable "name" {
  description = "Name of this environment, may be used for labels or to namespace created resources"
}

variable "cluster_name_prefix" {
  default     = ""
  description = "Optional prefix for the cluster. If specified, the cluster will be prefix.x.cld.gov.au"
}

variable "vpc_platform_id" {
  description = "VPC ID in this environment to use"
}

variable "cld_subdomain_zone_id" {
  description = "Public DNS Zone ID in this environment to use (e.g. $env_name.cld.gov.au)"
}

variable "int_cld_subdomain_zone_id" {}

variable "cld_internal_zone_id" {
  description = "Internal DNS Zone ID in this environment (xxx.net.cld.internal)"
}

variable "subnet_number" {
  description = "The N in 10.N.0.0 (used for all VPC IPs)"
}

variable "jumpbox_role_id" {
  description = "Jumpbox iam instance role id. The IAM permissions to run kops will be added to this"
}
