# This is the SQS queue where events will be sent as DMARC aggregate
# reports are received
resource "aws_sqs_queue" "queue" {
  name = "${var.queue_name}"
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 20

  redrive_policy = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue.arn}\",\"maxReceiveCount\":20}"

  tags = "${var.tags}"
}

# This is the dead-letter queue for the previous SQS queue
resource "aws_sqs_queue" "dead_letter_queue" {
  name = "${var.queue_name}_dead_letter"
  message_retention_seconds = 1209600

  tags = "${var.tags}"
}

# IAM policy document that that allows S3 to write to the queue
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
