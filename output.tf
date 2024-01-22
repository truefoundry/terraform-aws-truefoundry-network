###################################################################################
## VPC Output
###################################################################################
output "vpc_id" {
  description = "VPC ID of the network"
  value       = var.shim ? var.vpc_id : module.aws-vpc-module[0].vpc_id
}

output "private_subnets_id" {
  description = "List of private subnet IDs in the VPC"
  value       = var.shim ? var.private_subnets_ids : module.aws-vpc-module[0].private_subnets
}

output "public_subnets_id" {
  description = "List of public subnet IDs in the VPC"
  value       = var.shim ? var.public_subnets_ids : module.aws-vpc-module[0].public_subnets
}

output "private_subnets_cidrs" {
  description = "List of private subnet CIDRs in the VPC"
  value       = var.shim ? data.aws_subnet.private_subnets[*].cidr_block : var.private_subnets_cidrs
}

output "public_subnets_cidrs" {
  description = "List of public subnet CIDRs in the VPC"
  value       = var.shim ? data.aws_subnet.public_subnets[*].cidr_block : var.public_subnets_cidrs
}

output "region" {
  description = "AWS region of VPC"
  value       = var.aws_region
}
output "availability_zones" {
  description = "List of availability zones for VPC"
  value       = var.azs
}