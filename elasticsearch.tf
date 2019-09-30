# The CloudWatch log group where application logs will be written
resource "aws_cloudwatch_log_group" "es_logs" {
  name              = "/aws/aes/domains/${var.elasticsearch_domain_name}/application-logs"
  retention_in_days = 30

  tags = var.tags
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
  policy_name     = "dmarc-import-es-cloudwatch-policy"
  policy_document = data.aws_iam_policy_document.es_cloudwatch_doc.json
}

# The Elasticsearch domain
resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.elasticsearch_domain_name
  elasticsearch_version = "6.2"

  cluster_config {
    instance_type  = "m4.large.elasticsearch"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "standard"
    volume_size = 100
  }

  encrypt_at_rest {
    enabled = true
  }

  cognito_options {
    enabled = true
    # This stuff was set up manually.  See
    # https://github.com/cisagov/dmarc-import-terraform/issues/10.
    identity_pool_id = var.cognito_identity_pool_id
    role_arn         = var.cognito_role_arn
    user_pool_id     = var.cognito_user_pool_id
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.es_logs.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  tags = var.tags
}

# IAM policy document that allows the reporter user access to the
# Elasticsearch domain from anywhere.
# data "aws_iam_policy_document" "reporter_es_doc" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "es:ESHTTPGet"
#     ]
#     principals {
#       type = "AWS"
#       identifiers = [
#         "${aws_iam_user.reporter_user.arn}"
#       ]
#     }
#     # condition {
#     #   test = "IpAddress"
#     #   variable = "aws:SourceIp"
#     #   values = [
#     #     "X.Y.Z.W/32"
#     #   ]
#     # }
#     resources = [
#       "${aws_elasticsearch_domain.es.arn}/*"
#     ]
#   }
# }
# The access policy for the Elasticsearch domain
# resource "aws_elasticsearch_domain_policy" "cal_vpn" {
#   domain_name = "${aws_elasticsearch_domain.es.domain_name}"
#   access_policies = "${data.aws_iam_policy_document.reporter_es_doc.json}"
# }
