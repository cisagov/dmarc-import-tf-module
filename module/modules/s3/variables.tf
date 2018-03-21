variable "permanent_bucket_name" {
  type = "string"
  description = "The name to use for the the S3 bucket where the DMARC aggregate report emails are stored permanently"
}

variable "temporary_bucket_name" {
  type = "string"
  description = "The name to use for the the S3 bucket where the DMARC aggregate report emails are stored temporarily until they have been imported"
}
