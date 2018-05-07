# This is the name of the SQS queue where events will be sent as DMARC
# aggregate reports are received
resource "aws_sqs_queue" "dmarc_import_queue" {
  name = "${var.queue_name}"
  message_retention_seconds = 1209600
  receive_wait_time_seconds = 20
}
