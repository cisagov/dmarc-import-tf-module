variable "temporary_bucket_name" {
  type = "string"
  description = "The name to use for the the S3 bucket where the DMARC aggregate report emails are stored temporarily until they have been imported into the database"
}

variable "queue_arn" {
  type = "string"
  description = "The ARN of the SQS queue where events will be sent as DMARC aggregate reports are received"
}

variable "elasticsearch_arn" {
  type = "string"
  description = "The ARN of the Elasticsearch instance"
}

variable "lambda_function_name" {
  type = "string"
  description = "The name of the Lambda function that processes DMARC aggregate report emails"
}
