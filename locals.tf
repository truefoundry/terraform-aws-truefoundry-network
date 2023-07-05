locals {
  vpc_name = "${var.cluster_name}-vpc"

  flow_logs_bucket_arn = var.flow_logs_enable ? module.vpc_flow_logs_bucket[0].s3_bucket_arn : "not-an-arn"

  tags = merge(
    {
      "terraform-module" = "network"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )
}