###################################################################################
## VPC Output
###################################################################################
output "availability_zones" {
  value = var.azs
}

output "vpc_id" {
  value = var.shim == true ? var.vpc_id : module.aws-vpc-module[0].vpc_id
}

output "private_subnets_id" {
  value = var.shim == true ? var.private_subnets_ids : module.aws-vpc-module[0].private_subnets
}

output "public_subnets_id" {
  value = var.shim == true ? var.public_subnets_ids : module.aws-vpc-module[0].public_subnets
}