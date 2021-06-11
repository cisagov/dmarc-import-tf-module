# The AWS Lambda function that processes DMARC aggregate report emails
resource "aws_lambda_function" "lambda" {
  filename         = var.lambda_function_zip_file
  source_code_hash = filebase64sha256(var.lambda_function_zip_file)
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda.arn
  handler          = "lambda_handler.handler"
  runtime          = "python3.6"
  timeout          = 300
  memory_size      = 128
  description      = "Lambda function for processing DMARC aggregate report emails"

  environment {
    variables = {
      queue_url            = aws_sqs_queue.dmarc_reports.id
      elasticsearch_url    = "https://${aws_elasticsearch_domain.es.endpoint}"
      elasticsearch_index  = var.elasticsearch_index
      elasticsearch_region = var.aws_region
    }
  }
}

# Allows CloudWatch to invoke this Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "events.amazonaws.com"
}

# AWS CloudWatch rule to run the Lambda function
resource "aws_cloudwatch_event_rule" "lambda" {
  name                = "ImportDmarcAggregateReports"
  description         = "Run the Lambda function for importing DMARC aggregate report emails"
  schedule_expression = "rate(5 minutes)"
  is_enabled          = true
}

# Target for the CloudWatch rule
resource "aws_cloudwatch_event_target" "lambda" {
  arn  = aws_lambda_function.lambda.arn
  rule = aws_cloudwatch_event_rule.lambda.name
}

# The Cloudwatch log group for the Lambda function
resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 30
}
