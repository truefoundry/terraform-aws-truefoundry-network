data "aws_iam_policy_document" "flow_logs_bucket_policy" {
  count   = var.flow_logs_enable ? 1 : 0
  statement {
    sid    = "SecureTransportOnly"
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "*"
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "${local.flow_logs_bucket_arn}/*",
      local.flow_logs_bucket_arn,
    ]
    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions = ["s3:PutObject"]

    resources = [
      "${local.flow_logs_bucket_arn}/*",
      local.flow_logs_bucket_arn
    ]
    condition {
      test     = "StringEquals"
      values   = [var.aws_account_id]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:us-east-1:${var.aws_account_id}:*"]
      variable = "aws:SourceArn"
    }
  }
  statement {
    sid    = "AWSLogDeliveryCheck"
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket"
    ]

    resources = [
      "${local.flow_logs_bucket_arn}/*",
      local.flow_logs_bucket_arn
    ]
    condition {
      test     = "StringEquals"
      values   = [var.aws_account_id]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:us-east-1:${var.aws_account_id}:*"]
      variable = "aws:SourceArn"
    }
  }
}

module "vpc_flow_logs_bucket" {
  count   = var.flow_logs_enable ? 1 : 0
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.7.0"

  bucket        = var.flow_logs_bucket_enable_override ? var.flow_logs_bucket_override_name : null
  bucket_prefix = var.flow_logs_bucket_enable_override ? null : "${substr(var.cluster_name, 0, 24)}-vpc-flow-log"
  force_destroy = var.flow_logs_bucket_force_destroy

  tags = merge(
    {
      Name = "${var.cluster_name}-vpc-flow-logs"
    },
    local.tags
  )

  # Bucket policies
  policy                                = data.aws_iam_policy_document.flow_logs_bucket_policy[0].json
  attach_policy                         = false
  attach_deny_insecure_transport_policy = false
  attach_require_latest_tls_policy      = false

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  acl = "private" # "acl" conflicts with "grant" and "owner"

  versioning = {
    status     = false
    mfa_delete = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.flow_logs_bucket_encryption_key_arn
        sse_algorithm     = var.flow_logs_bucket_encryption_algorithm
      }
    }
  }

  intelligent_tiering = {
    general = {
      status = "Enabled"
      tiering = {
        ARCHIVE_ACCESS = {
          days = 90
        }
      }
    }
  }
}
