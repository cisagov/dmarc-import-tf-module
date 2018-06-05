# The Elasticsearch domain
resource "aws_elasticsearch_domain" "es" {
  domain_name = "${var.elasticsearch_domain_name}"
  elasticsearch_version = "6.2"

  cluster_config = {
    instance_type = "m4.large.elasticsearch"
    instance_count = 1
  }

  ebs_options = {
    ebs_enabled = true
    volume_type = "standard"
    volume_size = 100
  }

  encrypt_at_rest = {
    enabled = true
  }

  tags = "${var.tags}"
}

# IAM policy document that that allows unauthenticated access to the
# Elasticsearch domain from the CAL VPN.
data "aws_iam_policy_document" "cal_vpn_es_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "es:ESHTTPGet"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_user.reporter_user.arn}"
      ]
    }

    # condition {
    #   test = "IpAddress"
    #   variable = "aws:SourceIp"
    #   values = [
    #     "X.Y.Z.T/32"
    #   ]
    # }

    resources = [
      "${aws_elasticsearch_domain.es.arn}/*"
    ]
  }
}

# The access policy for the Elasticsearch domain
resource "aws_elasticsearch_domain_policy" "cal_vpn" {
  domain_name = "${aws_elasticsearch_domain.es.domain_name}"

  access_policies = "${data.aws_iam_policy_document.cal_vpn_es_doc.json}"
}
