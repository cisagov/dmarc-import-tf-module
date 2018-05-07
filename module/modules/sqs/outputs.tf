output "queue_arn" {
  value = "${aws_sqs_queue.queue.arn}"
  description = "The ARN of the SQS queue where events will be sent as DMARC aggregate reports are received"
}
