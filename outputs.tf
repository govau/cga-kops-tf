output "kops_state_store" {
  value = "s3://${aws_s3_bucket.kops_state_store.id}"
}
