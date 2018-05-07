# This is the S3 bucket where the DMARC aggregate report emails are
# stored *permanently*
resource "aws_s3_bucket" "permanent" {
  bucket = "${var.permanent_bucket_name}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# This is the S3 bucket where the DMARC aggregate report emails are
# stored "temporarily" until they have been processed
resource "aws_s3_bucket" "temporary" {
  bucket = "${var.temporary_bucket_name}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

# Lambda function that extracts DMARC aggregate reports from the
# emails, verifies them against the DMARC aggregate report XML schema,
# parses the reports, stores the report information in the
# Elasticsearch database, and (if all went well) deletes the message
# from the temporary bucket.
# resource "aws_lambda_function" "importer" {
#   filename = "${var.lambda_file}"
#   function_name = "${var.lambda_name}" # Should have a default of dmarc-import
#   role = "${var.role_arn}"
#   handler = "exports.example"
#   source_arn = "${aws_s3_bucket.temporary.arn}"
#   description = "Extracts DMARC aggregate reports from the emails, parses them, stores the report information in the Elasticsearch database, and deletes the message from the temporary bucket."
# }

# The Lambda permission that allows the temporary S3 bucket to launch
# the Lambda function
# resource "aws_lambda_permission" "lambda_perm" {
#   statement_id = "AllowLambdaExecutionFromDmarcImportTemporaryBucket"
#   action = "lambda:InvokeFunction"
#   function_name = "${aws_lambda_function.importer.arn}"
#   principal = "s3.amazonaws.com"
#   source_arn = "${aws_s3_bucket.temporary.arn}"
# }

# S3 bucket notification that fires off the Lambda function when an
# object is created in the temporary bucket
# resource "aws_s3_bucket_notification" "notification" {
#   bucket = "${aws_s3_bucket.temporary.id}"

#   lambda_function {
#     lambda_function_arn = "${aws_lambda_function.importer.arn}"
#     events = ["s3:ObjectCreated:*"]
#   }
# }
