# This is the S3 bucket where the DMARC aggregate report emails are
# stored *permanently*
resource "aws_s3_bucket" "permanent" {
  bucket = "${var.permanent_bucket_name}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = "${var.tags}"
}

# This is the S3 bucket where the DMARC aggregate report emails are
# stored "temporarily" until they have been processed
resource "aws_s3_bucket" "temporary" {
  bucket = "${var.temporary_bucket_name}"
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = "${var.tags}"
}

# We need the AWS account ID
data "aws_caller_identity" "current" {}

# IAM policy document that that allows SES to write to our permanent
# dmarc-import bucket.
data "aws_iam_policy_document" "ses_permanent_s3_doc" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.permanent.arn}/*"
    ]

    condition {
      test = "StringEquals"
      variable = "aws:Referer"
      values = [
        "${data.aws_caller_identity.current.account_id}"
      ]
    }
  }
}

# This is the policy for our permanent S3 bucket
resource "aws_s3_bucket_policy" "permanent_policy" {
  bucket = "${aws_s3_bucket.permanent.id}"
  policy = "${data.aws_iam_policy_document.ses_permanent_s3_doc.json}"
}

# IAM policy document that that allows SES to write to our
# temporary dmarc-import bucket.
data "aws_iam_policy_document" "ses_temporary_s3_doc" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.temporary.arn}/*"
    ]

    condition {
      test = "StringEquals"
      variable = "aws:Referer"
      values = [
        "${data.aws_caller_identity.current.account_id}"
      ]
    }
  }
}

# This is the policy for our temporary S3 bucket
resource "aws_s3_bucket_policy" "temporary_policy" {
  bucket = "${aws_s3_bucket.temporary.id}"
  policy = "${data.aws_iam_policy_document.ses_temporary_s3_doc.json}"
}

# S3 bucket notification that sends an event to the SQS queue when an
# object is created in the temporary bucket
resource "aws_s3_bucket_notification" "notification" {
  bucket = "${aws_s3_bucket.temporary.id}"

  queue {
    queue_arn = "${var.queue_arn}"
    events = ["s3:ObjectCreated:*"]
  }
}
