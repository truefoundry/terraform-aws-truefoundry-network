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

output "validate_private_subnet_tags" {
  description = "Validates that all private subnets have the required Kubernetes tags for proper ELB and cluster integration"
  value       = local.private_subnets_missing_tags
  precondition {
    condition     = length(local.private_subnets_missing_tags) == 0
    error_message = <<EOT
Some private subnets are missing required tags: ${jsonencode(local.private_subnets_missing_tags)}

Required tags for private subnets:
- "kubernetes.io/cluster/${var.cluster_name}": "shared"
- "subnet": "private"
- "kubernetes.io/role/internal-elb": "1"

See: https://docs.truefoundry.com/docs/requirements#vpc-tags
EOT
  }
}

output "validate_public_subnet_tags" {
  description = "Validates that all public subnets have the required Kubernetes tags for proper ELB and cluster integration"
  value       = local.public_subnets_missing_tags
  precondition {
    condition     = length(local.public_subnets_missing_tags) == 0
    error_message = <<EOT
Some public subnets are missing required tags: ${jsonencode(local.public_subnets_missing_tags)}

Required tags for public subnets:
- "kubernetes.io/cluster/${var.cluster_name}": "shared"
- "subnet": "public"
- "kubernetes.io/role/elb": "1"

See: https://docs.truefoundry.com/docs/requirements#vpc-tags
EOT
  }
}
