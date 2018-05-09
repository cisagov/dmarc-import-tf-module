resource "aws_lambda_function" "lambda" {
  filename = "${var.zip_file}"
  function_name = "${var.name}"
  role = "${var.role_arn}"
  handler = "lambda_handler.handler"
  runtime = "python3.6"
  timeout = 300
  memory_size = 128
  description = "Lambda function for processing DMARC aggregate report emails"

  # environment {
  #   variables = {
  #     foo = "bar"
  #   }
  # }
}

# Allows CloudWatch to invoke this Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal = "events.amazonaws.com"
}
