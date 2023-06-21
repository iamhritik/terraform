resource "aws_flow_log" "vpc_logging" {
  count = local.enable_vpc_logging
  log_destination_type     = var.destination_type
  log_destination = try(aws_cloudwatch_log_group.vpc_log_group[0].arn,aws_s3_bucket.logging_bucket[0].arn)
  log_format               = var.log_format
  iam_role_arn    = var.destination_type == "cloud-watch-logs" && var.iam_role_arn == null ? try(aws_iam_role.log_group_role[0].arn,null) : var.iam_role_arn 
  traffic_type    = var.traffic_type
  vpc_id          = aws_vpc.vpc_1.id
  max_aggregation_interval = var.max_aggregation_interval

  dynamic "destination_options" {
  for_each = var.destination_type == "s3" ? [true] : []

    content {
        file_format                = var.flow_log_file_format
        hive_compatible_partitions = var.flow_log_hive_compatible_partitions
        per_hour_partition         = var.flow_log_per_hour_partition
    }
  }
}

resource "aws_cloudwatch_log_group" "vpc_log_group" {
  count = local.create_cloudwatch_log_group
  name = var.cloudwatch_log_group_name == null ? "${var.vpc_name}_log_group" : var.cloudwatch_log_group_name
}


resource "random_id" "value" {
  byte_length = 8
}

resource "aws_s3_bucket" "logging_bucket" {
  count = local.create_logging_bucket
  force_destroy = true
  bucket = var.logging_bucket_name == null ? "vpc-flow-logs-${random_id.value.hex}" : var.logging_bucket_name
}


data "aws_iam_policy_document" "assume_role" {
  count = local.create_cloudwatch_log_group

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "log_group_role" {
  count = local.create_cloudwatch_log_group
  name               = "vpc-logging-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
}

data "aws_iam_policy_document" "policies" {
  count = local.create_cloudwatch_log_group

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "vpc_logging_policy" {
  count = local.create_cloudwatch_log_group
  name   = "VPC-flow-logs-policy"
  role   = aws_iam_role.log_group_role[0].id
  policy = data.aws_iam_policy_document.policies[0].json
}