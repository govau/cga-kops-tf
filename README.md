
# cga-kops-tf

A terraform module for bootstrapping the prerequisite AWS resources for using kops in cloud.gov.au.

This allows us to:

- Use our existing VPC ~~and NAT Gateways~~ (TODO)

- Creates kops [state store](https://github.com/kubernetes/kops/blob/master/docs/state.md) S3 bucket

- Configure jumpbox IAM permissions so we can run kops within each environment
