##################################################################################
## SHIM
##################################################################################
variable "shim" {
  description = "If true will not create the network and forward the input values to the same outputs."
  type        = bool
  default     = false
}
variable "vpc_id" {
  description = "SHIM: VPC Id"
  type        = string
  default     = ""
}
variable "public_subnets_ids" {
  description = "SHIM: Public Subnets IDs"
  type        = list(string)
  default     = []
}
variable "private_subnets_ids" {
  description = "SHIM: Private Subnets IDs"
  type        = list(string)
  default     = []
}

##################################################################################
## NON-SHIM
##################################################################################

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = ""
}
variable "private_subnets_cidrs" {
  description = "Assigns IPv4 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}
variable "public_subnets_cidrs" {
  description = "Assigns IPv4 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list"
  type        = list(string)
  default     = []
}
variable "public_subnet_extra_tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags for VPC public subnets"
}

variable "private_subnet_extra_tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags for VPC private subnets"
}
variable "enable_nat_gateway" {
  description = "Enable NAT Gateway - This is necessary for the cluster to work"
  default     = true
  type        = bool
}
variable "single_nat_gateway" {
  description = "Single NAT Gateway, shared for all AZ and subnets"
  default     = true
  type        = bool
}
variable "one_nat_gateway_per_az" {
  description = "One NAT Gateway for each AZ."
  default     = false
  type        = bool
}

##################################################################################
## Generic
##################################################################################

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}
variable "cluster_name" {
  description = "AWS EKS cluster name needed for Shared cluster"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "VPC region"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}

##################################################################################
## Flow logs
##################################################################################

variable "flow_logs_enable" {
  default     = false
  description = "Enable VPC flow logs"
  type        = bool
}

variable "flow_logs_bucket_attach_policy" {
  description = "Flag to attach policy to the bucket"
  type        = bool
  default     = true
}

variable "flow_logs_bucket_attach_deny_insecure_transport_policy" {
  description = "Flag to attach deny insecure transport policy to the bucket"
  type        = bool
  default     = true
}

variable "flow_logs_bucket_attach_require_latest_tls_policy" {
  description = "Flag to attach require latest TLS policy to the bucket"
  type        = bool
  default     = true
}

variable "flow_logs_bucket_attach_public_policy" {
  description = "Flag to attach public policy to the bucket"
  type        = bool
  default     = true
}

variable "flow_logs_bucket_block_public_acls" {
  description = "Flag to block public ACLs on the bucket"
  type        = bool
  default     = true
}

variable "flow_logs_bucket_block_public_policy" {
  description = "Flag to block public policy on the bucket"
  type        = bool
  default     = true
}
variable "flow_logs_bucket_ignore_public_acls" {
  description = "Flag to ignore public ACLs on the bucket"
  type        = bool
  default     = true
}

variable "flow_logs_bucket_restrict_public_buckets" {
  description = "Flag to restrict public buckets on the bucket"
  type        = bool
  default     = true
}

variable "flow_logs_bucket_encryption_algorithm" {
  description = "Algorithm used for encrypting the default bucket."
  type        = string
  default     = "AES256"
}
variable "flow_logs_bucket_force_destroy" {
  description = "Force destroy for the default bucket."
  type        = bool
  default     = false
}
variable "flow_logs_bucket_encryption_key_arn" {
  description = "ARN of the key used to encrypt the bucket. Only needed if you set aws:kms as encryption algorithm."
  type        = string
  default     = null
}
variable "flow_logs_bucket_enable_override" {
  description = "Enable override for s3 bucket name. You must pass flow_logs_bucket_override_name"
  type        = bool
  default     = false
}
variable "flow_logs_bucket_override_name" {
  description = "Override name for s3 bucket. flow_logs_bucket_enable_override must be set true"
  type        = string
  default     = ""
}
