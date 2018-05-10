variable "queue_name" {
  type = "string"
  description = "The name of the SQS queue where events will be sent as DMARC aggregate reports are received"
}

variable "tags" {
  type = "map"
  default = {}
  description = "Tags to apply to all AWS resources created"
}
