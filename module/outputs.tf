output "permanent_bucket_name" {
  value = "${module.s3.permanent_bucket_name}"
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored permanently"
}

output "temporary_bucket_name" {
  value = "${module.s3.temporary_bucket_name}"
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored temporarily until they are processed"
}

output "role_arn" {
  value = "${module.iam.role_arn}"
  description = "The ARN of the IAM role created with the proper permissions to import DMARC aggregate report emails"
}
