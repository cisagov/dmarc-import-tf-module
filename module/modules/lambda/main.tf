# We need the AWS region in order to pass it to the Lambda function
data "aws_region" "current" {}

# The AWS Lambda function that processes DMARC aggregate report emails
resource "aws_lambda_function" "lambda" {
  filename = "${var.zip_file}"
  source_code_hash = "${base64sha256(file("${var.zip_file}"))}"
  function_name = "${var.name}"
  role = "${var.role_arn}"
  handler = "lambda_handler.handler"
  runtime = "python3.6"
  timeout = 300
  memory_size = 128
  description = "Lambda function for processing DMARC aggregate report emails"

  environment {
    variables = {
      queue_url = "${var.queue_url}"
      elasticsearch_url = "https://${var.elasticsearch_endpoint}/${var.elasticsearch_index}/${var.elasticsearch_type}"
      elasticsearch_region = "${data.aws_region.current.name}"
    }
  }

  tags = "${var.tags}"
}

# Allows CloudWatch to invoke this Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal = "events.amazonaws.com"
}

# AWS CloudWatch rule to run the Lambda function
resource "aws_cloudwatch_event_rule" "lambda" {
  name = "ImportDmarcAggregateReports"
  description = "Run the Lambda function for importing DMARC aggregate report emails"
  schedule_expression = "rate(5 minutes)"
  is_enabled = true
}

# Target for the CloudWatch rule
resource "aws_cloudwatch_event_target" "lambda" {
  arn = "${aws_lambda_function.lambda.arn}"
  rule = "${aws_cloudwatch_event_rule.lambda.name}"
}

# The Cloudwatch log group for the Lambda function
resource "aws_cloudwatch_log_group" "logs" {
  name = "/aws/lambda/${var.name}"
  retention_in_days = 90

  tags = "${var.tags}"
}
