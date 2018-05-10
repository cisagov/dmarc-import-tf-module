variable "permanent_bucket_name" {
  type = "string"
  description = "The name of the S3 bucket where the DMARC aggregate report emails will be permanently stored"
}

variable "temporary_bucket_name" {
  type = "string"
  description = "The name of the S3 bucket where the DMARC aggregate report emails will be stored temporarily (until processed)"
}

variable "queue_arn" {
  type = "string"
  description = "The ARN of the SQS queue where events will be sent as DMARC aggregate reports are received"
}

variable "tags" {
  type = "map"
  default = {}
  description = "Tags to apply to all AWS resources created"
}
