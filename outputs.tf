output "kops_state_store" {
  value = "s3://${aws_s3_bucket.kops_state_store.id}"
}

output "cluster_name" {
  value = "${var.cluster_name_prefix}${var.cluster_name_prefix != "" ? "." : ""}${var.name}.cld.gov.au"
}
