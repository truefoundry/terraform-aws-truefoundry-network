locals {
  vpc_name = "${var.cluster_name}-vpc"

  flow_logs_bucket_arn = var.flow_logs_enable ? module.vpc_flow_logs_bucket[0].s3_bucket_arn : null

  tags = merge(
    {
      "terraform-module" = "network"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )
  required_private_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "subnet"                                    = "private"
    "kubernetes.io/role/internal-elb"           = "1"
  }
  required_public_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "subnet"                                    = "public"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnets_missing_tags = var.shim ? [
    for i, s in data.aws_subnet.private_subnets : {
      id      = s.id
      missing = [for k, v in local.required_private_tags : k if lookup(s.tags, k, null) != v]
    } if length([for k, v in local.required_private_tags : k if lookup(s.tags, k, null) != v]) > 0
  ] : []

  public_subnets_missing_tags = var.shim ? [
    for i, s in data.aws_subnet.public_subnets : {
      id      = s.id
      missing = [for k, v in local.required_public_tags : k if lookup(s.tags, k, null) != v]
    } if length([for k, v in local.required_public_tags : k if lookup(s.tags, k, null) != v]) > 0
  ] : []


}
