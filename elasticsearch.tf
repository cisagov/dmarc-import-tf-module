# The CloudWatch log group where application logs will be written
resource "aws_cloudwatch_log_group" "es_logs" {
  name              = "/aws/aes/domains/${var.elasticsearch_domain_name}/application-logs"
  retention_in_days = 30
}

# IAM policy document that that allows ES to write to CloudWatch logs
data "aws_iam_policy_document" "es_cloudwatch_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }

    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
    ]

    resources = [
      aws_cloudwatch_log_group.es_logs.arn,
    ]
  }
}

resource "aws_cloudwatch_log_resource_policy" "es_cloudwatch_policy" {
  policy_document = data.aws_iam_policy_document.es_cloudwatch_doc.json
  policy_name     = "dmarc-import-es-cloudwatch-policy"
}

# The Elasticsearch domain
resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.elasticsearch_domain_name
  elasticsearch_version = "OpenSearch_1.3"

  cluster_config {
    instance_type  = "m6g.large.elasticsearch"
    instance_count = 3
    zone_awareness_config {
      availability_zone_count = 3
    }
    zone_awareness_enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 100
  }

  encrypt_at_rest {
    enabled = true
  }

  # cognito_options {
  #   enabled = true
  #   # This stuff was set up manually.  See
  #   # https://github.com/cisagov/dmarc-import-terraform/issues/10.
  #   identity_pool_id = var.cognito_identity_pool_id
  #   role_arn         = var.cognito_role_arn
  #   user_pool_id     = var.cognito_user_pool_id
  # }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_logs.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }
}
