# This is the name of the SQS queue where events will be sent as DMARC
# aggregate reports are received
resource "aws_sqs_queue" "queue" {
  name = "${var.queue_name}"
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 20
}

# IAM policy document that that allows SES to write to our permanent
# dmarc-import bucket.
data "aws_iam_policy_document" "s3_sqs_doc" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    
    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      "${aws_sqs_queue.queue.arn}"
    ]
  }
}

# This is the policy for our SQS queue
resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = "${aws_sqs_queue.queue.id}"
  policy = "${data.aws_iam_policy_document.s3_sqs_doc.json}"
}