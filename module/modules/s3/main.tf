# This is the S3 bucket where the DMARC aggregate report emails are
# stored *permanently*
resource "aws_s3_bucket" "permanent" {
  bucket = "${var.permanent_bucket_name}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# This is the S3 bucket where the DMARC aggregate report emails are
# stored "temporarily" until they have been processed
resource "aws_s3_bucket" "temporary" {
  bucket = "${var.temporary_bucket_name}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
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
