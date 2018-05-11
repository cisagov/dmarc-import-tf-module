output "permanent_bucket_arn" {
  value = "${aws_s3_bucket.permanent.arn}"
  description = "The ARN of the permanent S3 bucket"
}

output "temporary_bucket_arn" {
  value = "${aws_s3_bucket.temporary.arn}"
  description = "The ARN of the temporary S3 bucket"
}
