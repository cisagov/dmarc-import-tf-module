variable "permanent_bucket_name" {
  type = "string"
  description = "The name of the S3 bucket where the DMARC aggregate report emails will be permanently stored"
}

variable "temporary_bucket_name" {
  type = "string"
  description = "The name of the S3 bucket where the DMARC aggregate report emails will be stored temporarily (until processed)"
}
