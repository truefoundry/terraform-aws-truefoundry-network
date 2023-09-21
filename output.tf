###################################################################################
## VPC Output
###################################################################################
output "availability_zones" {
  value = var.azs
}

output "vpc_id" {
  value = var.shim ? var.vpc_id : module.aws-vpc-module[0].vpc_id
}

output "private_subnets_id" {
  value = var.shim ? var.private_subnets_ids : module.aws-vpc-module[0].private_subnets
}

output "public_subnets_id" {
  value = var.shim ? var.public_subnets_ids : module.aws-vpc-module[0].public_subnets
}

output "private_subnets_cidrs" {
  value = var.shim ? data.aws_subnet.private_subnets[*].cidr_block : var.private_subnets_cidrs
}

output "public_subnets_cidrs" {
  value = var.shim ? data.aws_subnet.public_subnets[*].cidr_block : var.public_subnets_cidrs
}