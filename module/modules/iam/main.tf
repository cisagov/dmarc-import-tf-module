# IAM assume role policy document for the role we're creating
data "aws_iam_policy_document" "assume_role_doc" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# The role we're creating
resource "aws_iam_role" "role" {
  name = "dmarc-importer-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_doc.json}"
}

# IAM policy document that that allows some S3 permissions on our
# dmarc-import buckets.  This will be applied to the role we are
# creating.
data "aws_iam_policy_document" "s3_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectTorrent"
    ]

    resources = [
      "arn:aws:s3:::${var.permanent_bucket_name}",
      "arn:aws:s3:::${var.permanent_bucket_name}/*",
      "arn:aws:s3:::${var.temporary_bucket_name}",
      "arn:aws:s3:::${var.temporary_bucket_name}/*"
    ]
  }

  # Elasticsearch permissions
  statement {
    effect = "Allow"
    
    actions = ["es:*"]

    resources = ["*"]
  }
}

# IAM policy document that that allows all Elasticsearch permissions.
# This will be applied to the role we are creating.
data "aws_iam_policy_document" "es_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectTorrent"
    ]

    resources = [
      "arn:aws:s3:::${var.permanent_bucket_name}",
      "arn:aws:s3:::${var.permanent_bucket_name}/*",
      "arn:aws:s3:::${var.temporary_bucket_name}",
      "arn:aws:s3:::${var.temporary_bucket_name}/*"
    ]
  }

  # Elasticsearch permissions
  statement {
    effect = "Allow"
    
    actions = ["es:*"]

    resources = ["*"]
  }
}

# The S3 policy for our role
resource "aws_iam_role_policy" "s3_policy" {
  name = "dmarc-import-s3-read"
  role = "${aws_iam_role.role.id}"

  policy = "${data.aws_iam_policy_document.s3_doc.json}"
}

# The Elasticsearch policy for our role
resource "aws_iam_role_policy" "es_policy" {
  name = "dmarc-import-es-full"
  role = "${aws_iam_role.role.id}"

  policy = "${data.aws_iam_policy_document.es_doc.json}"
}
