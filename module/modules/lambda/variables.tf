variable "name" {
  type = "string"
  description = "The name to use for the Lambda function"
}

variable "zip_file" {
  type = "string"
  description = "The location of the zip file for the Lambda function"
}

variable "role_arn" {
  type = "string"
  description = "The ARN of the AWS role to use when running the Lambda function"
}

variable "queue_url" {
  type = "string"
  description = "The URL of the SQS queue where events will be sent as DMARC aggregate reports are received"
}

variable "elasticsearch_endpoint" {
  type = "string"
  description = "The endpoint of the Elasticsearch instance"
}

variable "elasticsearch_index" {
  type = "string"
  description = "The Elasticsearch index to which to write DMARC aggregate report data"
}
