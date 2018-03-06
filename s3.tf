resource "aws_s3_bucket" "permanent" {
  bucket = "cyhy-dmarc-report-emails"
  acl    = "private"
}

resource "aws_s3_bucket" "temporary" {
  bucket = "dmarc-import"
  acl    = "private"
}
