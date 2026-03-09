module "aws-vpc-module" {
  count   = var.shim == true ? 0 : 1
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

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
  reuse_nat_ips                 = var.use_external_elastic_ips
  external_nat_ip_ids           = var.external_nat_ip_ids

  enable_flow_log           = var.flow_logs_enable
  flow_log_destination_type = var.flow_logs_enable ? "s3" : null
  flow_log_destination_arn  = var.flow_logs_enable ? module.vpc_flow_logs_bucket[0].s3_bucket_arn : null
  flow_log_log_format       = "$${version} $${account-id} $${instance-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${az-id} $${pkt-srcaddr} $${pkt-dstaddr} $${pkt-src-aws-service} $${pkt-dst-aws-service} $${flow-direction} $${traffic-path}"
  vpc_flow_log_tags         = local.tags

  secondary_cidr_blocks = var.secondary_cidr_block

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


resource "aws_subnet" "custom_networking_eks_pods" {
  count = var.shim == true || length(var.secondary_cidr_block) == 0 ? 0 : length(var.eks_pod_secondary_subnet_cidrs)

  vpc_id            = module.aws-vpc-module[0].vpc_id
  cidr_block        = var.eks_pod_secondary_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(local.tags, {
    Name                               = "${var.cluster_name}-pod-${var.azs[count.index]}"
    "custom_networking_eks_pod_subnet" = "1"
    "subnet"                           = "private"
  })

  depends_on = [module.aws-vpc-module]
}

resource "aws_route_table_association" "custom_networking_eks_pods" {
  count = var.shim == true || length(var.secondary_cidr_block) == 0 ? 0 : length(var.eks_pod_secondary_subnet_cidrs)

  subnet_id      = aws_subnet.custom_networking_eks_pods[count.index].id
  route_table_id = element(module.aws-vpc-module[0].private_route_table_ids, count.index)
}
