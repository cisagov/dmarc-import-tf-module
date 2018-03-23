# This is the S3 bucket where the DMARC aggregate report emails are
# stored *permanently*
resource "aws_s3_bucket" "permanent" {
  bucket_prefix = "${var.bucket_prefix}"

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
  bucket = "${var.bucket_prefix}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}
