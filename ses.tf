resource "aws_ses_receipt_rule_set" "rules" {
  rule_set_name = "dmarc-import"
}

resource "aws_ses_receipt_rule" "rule" {
  name = "dmarc-emails"
  rule_set_name = "dmarc-import"
  recipients = [
    "reports@dmarc.cyber.dhs.gov",
    "reports@dmarc.cyber.secure-fed.org"
  ]
  enabled = true
  scan_enabled = true

  s3_action {
    bucket_name = "cyhy-dmarc-report-emails"
    position = 0
  }

  s3_action {
    bucket_name = "dmarc-import"
    position = 1
  }

  # lambda_action {
  #   function_arn = ??
  #   invocation_type = "Event"
  #   position = 2
  # }
}
