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
