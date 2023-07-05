module "aws-vpc-module" {
  count   = var.shim == true ? 0 : 1
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = local.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets_cidrs
  public_subnets  = var.public_subnets_cidrs

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  enable_dns_hostnames   = true
  enable_dns_support     = true


  enable_flow_log           = var.flow_logs_enable
  flow_log_destination_type = var.flow_logs_enable ? "s3" : null
  flow_log_destination_arn  = var.flow_logs_enable ? module.vpc_flow_logs_bucket[0].s3_bucket_arn : null
  flow_log_log_format       = "$${version} $${account-id} $${instance-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${az-id} $${pkt-srcaddr} $${pkt-dstaddr} $${pkt-src-aws-service}  $${pkt-dst-aws-service}  $${flow-direction}  $${traffic-path}"
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
