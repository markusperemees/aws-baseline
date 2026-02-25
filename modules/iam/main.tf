locals {
  name_prefix = "${var.project_name}-${var.environment}"
  default_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
  common_tags = merge(var.tags, local.default_tags)
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_least_privilege" {
  statement {
    sid = "CloudWatchLogsWrite"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    sid = "CloudWatchMetricsWrite"
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }

  statement {
    sid = "SsmParameterRead"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${local.name_prefix}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = local.common_tags
}

resource "aws_iam_policy" "ec2_least_privilege" {
  name        = "${local.name_prefix}-ec2-least-privilege"
  description = "Least-privilege policy for EC2 logging, metrics, and SSM parameter read"
  policy      = data.aws_iam_policy_document.ec2_least_privilege.json
  tags        = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ec2_least_privilege" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2_least_privilege.arn
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "backup_s3_write" {
  count = var.backup_bucket_arn == null ? 0 : 1

  statement {
    sid = "BackupBucketListPrefix"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [var.backup_bucket_arn]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${var.backup_bucket_prefix}/*"]
    }
  }

  statement {
    sid = "BackupObjectWrite"
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]
    resources = ["${var.backup_bucket_arn}/${var.backup_bucket_prefix}/*"]
  }
}

resource "aws_iam_role_policy" "backup_s3_write" {
  count = var.backup_bucket_arn == null ? 0 : 1

  name   = "${local.name_prefix}-backup-s3-write"
  role   = aws_iam_role.ec2.id
  policy = data.aws_iam_policy_document.backup_s3_write[0].json
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${local.name_prefix}-ec2-instance-profile"
  role = aws_iam_role.ec2.name
  tags = local.common_tags
}
