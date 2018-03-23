output "permanent_bucket_name" {
  value = "${aws_s3_bucket.permanent.id}"
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored permanently"
}

output "temporary_bucket_name" {
  value = "${aws_s3_bucket.temporary.id}"
  description = "The name of the S3 bucket where the DMARC aggregate report emails are stored temporarily until they are processed"
}
