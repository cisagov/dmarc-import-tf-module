resource "aws_lambda_function" "lambda" {
  filename = "${var.zip_file}"
  function_name = "${var.name}"
  role = "${var.role_arn}"
  handler = "lambda_handler.handler"
  runtime = "python3.6"
  timeout = 300
  memory_size = 128
  description = "Lambda function for processing DMARC aggregate report emails"
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
  schedule_expression = "rate(7 minutes)"
  is_enabled = false
}

# Target for the CloudWatch rule
resource "aws_cloudwatch_event_target" "lambda" {
  arn = "${aws_lambda_function.lambda.arn}"
  rule = "${aws_cloudwatch_event_rule.lambda.name}"
}
