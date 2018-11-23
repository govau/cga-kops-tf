# Cluster State storage
# https://github.com/kubernetes/kops/blob/master/docs/aws.md#cluster-state-storage
resource "aws_s3_bucket" "kops_state_store" {
  bucket_prefix = "${var.name}-kops-state-store-"

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

locals {
  # We are deploying kops into an existing VPC. Kops will create 6 subnets. We
  # will base the CIDR's for each from this number - this number is chosen so
  # as not to collide with other existing subnets in cga.
  # https://github.com/kubernetes/kops/blob/master/docs/run_in_existing_vpc.md
  base_cluster_cidr = 44
}

# DNS TXT record to pass env specific metadata/config to the kops installer
resource "aws_route53_record" "cld_internal_net_kops_txt" {
  zone_id = "${var.cld_internal_zone_id}"
  name    = "kops.cld.internal."
  type    = "TXT"
  ttl     = 300

  records = [
    "state-store=s3://${aws_s3_bucket.kops_state_store.id}",
    "cluster-name-prefix=${var.cluster_name_prefix}",
    "private-subnet-cidr-a=10.${var.subnet_number}.${local.base_cluster_cidr}.128/25",
    "private-subnet-cidr-b=10.${var.subnet_number}.${local.base_cluster_cidr+1}.0/25",
    "private-subnet-cidr-c=10.${var.subnet_number}.${local.base_cluster_cidr+1}.128/25",
    "utility-subnet-cidr-a=10.${var.subnet_number}.${local.base_cluster_cidr}.0/28",
    "utility-subnet-cidr-b=10.${var.subnet_number}.${local.base_cluster_cidr}.16/28",
    "utility-subnet-cidr-c=10.${var.subnet_number}.${local.base_cluster_cidr}.32/28",
  ]
}

# The jumpbox deploys kops, so we add the required policies to it
# https://github.com/kubernetes/kops/blob/master/docs/aws.md#setup-iam-user
locals {
  policies = [
    "AmazonEC2FullAccess",
    "AmazonRoute53FullAccess",
    "AmazonS3FullAccess",
    "IAMFullAccess",
    "AmazonVPCFullAccess",
  ]
}

resource "aws_iam_role_policy_attachment" "jumpbox" {
  role       = "${var.jumpbox_role_id}"
  policy_arn = "arn:aws:iam::aws:policy/${local.policies[count.index]}"
  count      = "${length(local.policies)}"
}
