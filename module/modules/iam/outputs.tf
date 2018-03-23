output "role_arn" {
  value = "${aws_iam_role.role.arn}"
  description = "The ARN of the IAM role created with the proper permissions to import DMARC aggregate report emails"
}
