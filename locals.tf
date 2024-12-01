locals {
  vpc_name = "${var.cluster_name}-vpc"

  flow_logs_bucket_arn = var.flow_logs_enable ? module.vpc_flow_logs_bucket[0].s3_bucket_arn : null

  # Base tags for all resources
  tags = merge(
    {
      "terraform-module" = "network"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )

  # Define base tags that match the VPC module's tags
  private_subnet_base_tags = merge(
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"           = "1"
      "subnet"                                    = "private"
    },
    var.private_subnet_extra_tags,
    local.tags
  )

  public_subnet_base_tags = merge(
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb"                    = "1"
      "subnet"                                    = "public"
    },
    var.public_subnet_extra_tags,
    local.tags
  )

  # Convert all tags to list format for aws_ec2_tag resources
  private_subnet_tags_list = [
    for k, v in local.private_subnet_base_tags : {
      key   = k
      value = v
    }
  ]

  public_subnet_tags_list = [
    for k, v in local.public_subnet_base_tags : {
      key   = k
      value = v
    }
  ]
}
