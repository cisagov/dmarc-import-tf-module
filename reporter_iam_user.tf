# The IAM user used by the reporter process to pull DMARC aggregation
# report data for incorporation into the Trustworthy Email report
resource "aws_iam_user" "reporter_user" {
  name = "reporter"
}

# The access key for our IAM user
resource "aws_iam_access_key" "reporter_user_key" {
  user = "${aws_iam_user.reporter_user.name}"
}

# IAM policy document that only allows GETting from Elasticsearch.
# This will be applied to the role we are creating.
data "aws_iam_policy_document" "reporter_user_es_doc" {
  statement {
    effect = "Allow"

    actions = [
      "es:ESHttpGet"
    ]

    resources = [
      "${aws_elasticsearch_domain.es.arn}",
      "${aws_elasticsearch_domain.es.arn}/*"
    ]
  }
}

# The IAM user policy for our user
resource "aws_iam_user_policy" "reporter_user_policy" {
  user = "${aws_iam_user.reporter_user.name}"
  policy = "${data.aws_iam_policy_document.reporter_user_es_doc.json}"
}

# The AWS access key ID for the reporter user
output "reporter_access_key_id" {
  value = "${aws_iam_access_key.reporter_user_key.id}"
  description = "The access key ID for the reporter IAM user"
}

# The AWS secret access key for the reporter user
output "reporter_secret_access_key" {
  value = "${aws_iam_access_key.reporter_user_key.secret}"
  description = "The secret access key for the reporter IAM user"
}
