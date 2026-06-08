# Plan-only tag propagation test for terraform-aws-truefoundry-network.
# Uses mock_provider so no AWS credentials are required.
# Asserts that:
#   1. Caller-supplied tags appear on a root-module resource (aws_vpc_endpoint.s3).
#   2. Module-managed default tags (terraform-module, terraform, cluster-name) appear.
#   3. When disable_default_tags = true, default tags are absent.

mock_provider "aws" {}

# ── run 1: default tags + caller tags are merged ────────────────────────────
run "tags_merged" {
  command = plan

  variables {
    cluster_name          = "test"
    aws_account_id        = "123456789012"
    aws_region            = "us-east-1"
    azs                   = ["us-east-1a", "us-east-1b", "us-east-1c"]
    vpc_cidr              = "10.0.0.0/16"
    private_subnets_cidrs = ["10.0.0.0/20"]
    public_subnets_cidrs  = ["10.0.128.0/20"]
    tags = {
      "cost-center" = "test-123"
    }
  }

  # The aws_vpc_endpoint.s3 resource is directly in the root module and receives local.tags.
  assert {
    condition     = aws_vpc_endpoint.s3[0].tags["cost-center"] == "test-123"
    error_message = "caller tag 'cost-center' was not propagated to aws_vpc_endpoint.s3"
  }

  assert {
    condition     = aws_vpc_endpoint.s3[0].tags["terraform-module"] == "network"
    error_message = "default tag 'terraform-module=network' was not set on aws_vpc_endpoint.s3"
  }

  assert {
    condition     = aws_vpc_endpoint.s3[0].tags["terraform"] == "true"
    error_message = "default tag 'terraform=true' was not set on aws_vpc_endpoint.s3"
  }

  assert {
    condition     = aws_vpc_endpoint.s3[0].tags["cluster-name"] == "test"
    error_message = "default tag 'cluster-name=test' was not set on aws_vpc_endpoint.s3"
  }
}

# ── run 2: disable_default_tags suppresses module defaults ──────────────────
run "disable_default_tags" {
  command = plan

  variables {
    cluster_name          = "test"
    aws_account_id        = "123456789012"
    aws_region            = "us-east-1"
    azs                   = ["us-east-1a", "us-east-1b", "us-east-1c"]
    vpc_cidr              = "10.0.0.0/16"
    private_subnets_cidrs = ["10.0.0.0/20"]
    public_subnets_cidrs  = ["10.0.128.0/20"]
    disable_default_tags  = true
    tags = {
      "cost-center" = "test-123"
    }
  }

  assert {
    condition     = aws_vpc_endpoint.s3[0].tags["cost-center"] == "test-123"
    error_message = "caller tag 'cost-center' should still be present when disable_default_tags=true"
  }

  assert {
    condition     = !contains(keys(aws_vpc_endpoint.s3[0].tags), "terraform-module")
    error_message = "default tag 'terraform-module' should be absent when disable_default_tags=true"
  }
}
