# terraform-aws-truefoundry-network
Truefoundry AWS Network Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.57.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-vpc-module"></a> [aws-vpc-module](#module\_aws-vpc-module) | terraform-aws-modules/vpc/aws | 5.0.0 |
| <a name="module_vpc_flow_logs_bucket"></a> [vpc\_flow\_logs\_bucket](#module\_vpc\_flow\_logs\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_iam_policy_document.flow_logs_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account ID | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | VPC region | `string` | n/a | yes |
| <a name="input_azs"></a> [azs](#input\_azs) | Availability Zones | `list(string)` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | AWS EKS cluster name needed for Shared cluster | `string` | `""` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Enable NAT Gateway - This is necessary for the cluster to work | `bool` | `true` | no |
| <a name="input_flow_logs_bucket_enable_override"></a> [flow\_logs\_bucket\_enable\_override](#input\_flow\_logs\_bucket\_enable\_override) | Enable override for s3 bucket name. You must pass flow\_logs\_bucket\_override\_name | `bool` | `false` | no |
| <a name="input_flow_logs_bucket_encryption_algorithm"></a> [flow\_logs\_bucket\_encryption\_algorithm](#input\_flow\_logs\_bucket\_encryption\_algorithm) | Algorithm used for encrypting the default bucket. | `string` | `"AES256"` | no |
| <a name="input_flow_logs_bucket_encryption_key_arn"></a> [flow\_logs\_bucket\_encryption\_key\_arn](#input\_flow\_logs\_bucket\_encryption\_key\_arn) | ARN of the key used to encrypt the bucket. Only needed if you set aws:kms as encryption algorithm. | `string` | `null` | no |
| <a name="input_flow_logs_bucket_force_destroy"></a> [flow\_logs\_bucket\_force\_destroy](#input\_flow\_logs\_bucket\_force\_destroy) | Force destroy for the default bucket. | `bool` | `false` | no |
| <a name="input_flow_logs_bucket_override_name"></a> [flow\_logs\_bucket\_override\_name](#input\_flow\_logs\_bucket\_override\_name) | Override name for s3 bucket. flow\_logs\_bucket\_enable\_override must be set true | `string` | `""` | no |
| <a name="input_flow_logs_enable"></a> [flow\_logs\_enable](#input\_flow\_logs\_enable) | Enable VPC flow logs | `bool` | `false` | no |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | One NAT Gateway for each AZ. | `bool` | `false` | no |
| <a name="input_private_subnet_extra_tags"></a> [private\_subnet\_extra\_tags](#input\_private\_subnet\_extra\_tags) | Extra tags for VPC private subnets | `map(string)` | `{}` | no |
| <a name="input_private_subnets_cidrs"></a> [private\_subnets\_cidrs](#input\_private\_subnets\_cidrs) | Assigns IPv4 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list | `list(string)` | `[]` | no |
| <a name="input_private_subnets_ids"></a> [private\_subnets\_ids](#input\_private\_subnets\_ids) | SHIM: Private Subnets IDs | `list(string)` | `[]` | no |
| <a name="input_public_subnet_extra_tags"></a> [public\_subnet\_extra\_tags](#input\_public\_subnet\_extra\_tags) | Extra tags for VPC public subnets | `map(string)` | `{}` | no |
| <a name="input_public_subnets_cidrs"></a> [public\_subnets\_cidrs](#input\_public\_subnets\_cidrs) | Assigns IPv4 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to the corresponding IPv4 subnet list | `list(string)` | `[]` | no |
| <a name="input_public_subnets_ids"></a> [public\_subnets\_ids](#input\_public\_subnets\_ids) | SHIM: Public Subnets IDs | `list(string)` | `[]` | no |
| <a name="input_shim"></a> [shim](#input\_shim) | If true will not create the network and forward the input values to the same outputs. | `bool` | `false` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Single NAT Gateway, shared for all AZ and subnets | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS Tags common to all the resources created | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block for the VPC. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | SHIM: VPC Id | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | List of availability zones for VPC |
| <a name="output_private_subnets_cidrs"></a> [private\_subnets\_cidrs](#output\_private\_subnets\_cidrs) | List of private subnet CIDRs in the VPC |
| <a name="output_private_subnets_id"></a> [private\_subnets\_id](#output\_private\_subnets\_id) | List of private subnet IDs in the VPC |
| <a name="output_public_subnets_cidrs"></a> [public\_subnets\_cidrs](#output\_public\_subnets\_cidrs) | List of public subnet CIDRs in the VPC |
| <a name="output_public_subnets_id"></a> [public\_subnets\_id](#output\_public\_subnets\_id) | List of public subnet IDs in the VPC |
| <a name="output_region"></a> [region](#output\_region) | AWS region of VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID of the network |
<!-- END_TF_DOCS -->