module "aws-vpc-module" {
  count   = var.shim == true ? 0 : 1
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = local.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets_cidrs
  public_subnets  = var.public_subnets_cidrs

  enable_nat_gateway            = var.enable_nat_gateway
  single_nat_gateway            = var.single_nat_gateway
  one_nat_gateway_per_az        = var.one_nat_gateway_per_az
  enable_dns_hostnames          = true
  enable_dns_support            = true
  map_public_ip_on_launch       = true
  manage_default_security_group = false
  manage_default_route_table    = false
  manage_default_network_acl    = false


  enable_flow_log           = var.flow_logs_enable
  flow_log_destination_type = var.flow_logs_enable ? "s3" : null
  flow_log_destination_arn  = var.flow_logs_enable ? module.vpc_flow_logs_bucket[0].s3_bucket_arn : null
  flow_log_log_format       = "$${version} $${account-id} $${instance-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${az-id} $${pkt-srcaddr} $${pkt-dstaddr} $${pkt-src-aws-service} $${pkt-dst-aws-service} $${flow-direction} $${traffic-path}"
  vpc_flow_log_tags         = local.tags

  public_subnet_tags = merge(
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb"                    = "1"
      "subnet"                                    = "public"
    },
    var.public_subnet_extra_tags
  )

  private_subnet_tags = merge(
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"           = "1"
      "subnet"                                    = "private"
    },
    var.private_subnet_extra_tags
  )


  tags       = local.tags
  depends_on = [module.vpc_flow_logs_bucket]
}

resource "aws_vpc_endpoint" "s3" {
  count        = var.shim == true ? 0 : 1
  vpc_id       = module.aws-vpc-module[0].vpc_id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  tags         = local.tags
}

<<<<<<< Updated upstream
data "aws_subnet" "private_subnets" {
  count = var.shim ? length(var.private_subnets_ids) : 0

  id = element(var.private_subnets_ids, count.index)
}

data "aws_subnet" "public_subnets" {
  count = var.shim ? length(var.public_subnets_ids) : 0

  id = element(var.public_subnets_ids, count.index)
}
||||||| Stash base
data "aws_subnet" "private_subnets" {
  count = var.shim ? length(var.private_subnets_ids) : 0

  id = element(var.private_subnets_ids, count.index)
}

data "aws_subnet" "public_subnets" {
  count = var.shim ? length(var.public_subnets_ids) : 0

  id = element(var.public_subnets_ids, count.index)
}

resource "aws_ec2_tag" "private_subnet_tags" {
  count = var.shim ? length(var.private_subnets_ids) * length(local.private_subnet_tags_list) : 0

  resource_id = var.private_subnets_ids[floor(count.index / length(local.private_subnet_tags_list))]
  key         = local.private_subnet_tags_list[count.index % length(local.private_subnet_tags_list)].key
  value       = local.private_subnet_tags_list[count.index % length(local.private_subnet_tags_list)].value
}

resource "aws_ec2_tag" "public_subnet_tags" {
  count = var.shim ? length(var.public_subnets_ids) * length(local.public_subnet_tags_list) : 0

  resource_id = var.public_subnets_ids[floor(count.index / length(local.public_subnet_tags_list))]
  key         = local.public_subnet_tags_list[count.index % length(local.public_subnet_tags_list)].key
  value       = local.public_subnet_tags_list[count.index % length(local.public_subnet_tags_list)].value
}
=======
resource "aws_ec2_tag" "private_subnet_tags" {
  count = var.shim ? length(var.private_subnets_ids) * length(local.private_subnet_tags_list) : 0

  resource_id = var.private_subnets_ids[floor(count.index / length(local.private_subnet_tags_list))]
  key         = local.private_subnet_tags_list[count.index % length(local.private_subnet_tags_list)].key
  value       = local.private_subnet_tags_list[count.index % length(local.private_subnet_tags_list)].value
}

resource "aws_ec2_tag" "public_subnet_tags" {
  count = var.shim ? length(var.public_subnets_ids) * length(local.public_subnet_tags_list) : 0

  resource_id = var.public_subnets_ids[floor(count.index / length(local.public_subnet_tags_list))]
  key         = local.public_subnet_tags_list[count.index % length(local.public_subnet_tags_list)].key
  value       = local.public_subnet_tags_list[count.index % length(local.public_subnet_tags_list)].value
}
>>>>>>> Stashed changes
