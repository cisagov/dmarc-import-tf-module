# Stash the name of our rule set, so it is defined in only one place
locals {
  rule_set_name = "dmarc-import-rules"
}

# Make a new rule set for handling the DMARC aggregate report emails
# that arrive
resource "aws_ses_receipt_rule_set" "rules" {
  rule_set_name = "${local.rule_set_name}"
}

# Make a rule for handling the DMARC aggregate report emails that
# arrive
resource "aws_ses_receipt_rule" "rule" {
  name = "receive-dmarc-emails"
  rule_set_name = "${local.rule_set_name}"
  recipients = "${var.emails}"

  enabled = true
  scan_enabled = true

  # Save to the permanent S3 bucket
  s3_action {
    bucket_name = "${var.permanent_bucket_name}"
    position = 0
  }

  # Save to the temporary S3 bucket
  s3_action {
    bucket_name = "${var.temporary_bucket_name}"
    position = 1
  }

  # lambda_action {
  #   function_arn = ??
  #   invocation_type = "Event"
  #   position = 2
  # }
}

# Make this rule set the active one
resource "aws_ses_active_receipt_rule_set" "active" {
  rule_set_name = "${local.rule_set_name}"
}
