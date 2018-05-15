# IAM assume role policy document for the role we're creating
data "aws_iam_policy_document" "assume_role_doc" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# The role we're creating
resource "aws_iam_role" "role" {
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_doc.json}"
}

# IAM policy document that that allows some S3 permissions on our
# temporary dmarc-import bucket.  This will be applied to the role we
# are creating.
data "aws_iam_policy_document" "s3_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${var.temporary_bucket_arn}/*"
    ]
  }
}

# The S3 policy for our role
resource "aws_iam_role_policy" "s3_policy" {
  role = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.s3_doc.json}"
}

# IAM policy document that that allows all Elasticsearch permissions.
# This will be applied to the role we are creating.
data "aws_iam_policy_document" "es_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "es:ESHttpDelete",
      "es:ESHttpGet",
      "es:ESHttpHead",
      "es:ESHttpPost",
      "es:ESHttpPut",
    ]
    
    resources = [
      "${var.elasticsearch_arn}",
      "${var.elasticsearch_arn}/*"
    ]
  }
}

# The Elasticsearch policy for our role
resource "aws_iam_role_policy" "es_policy" {
  role = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.es_doc.json}"
}

# IAM policy document that that allows some SQS permissions on our
# dmarc-import queue.  This will be applied to the role we are
# creating.
data "aws_iam_policy_document" "sqs_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
    ]

    resources = [
      "${var.queue_arn}"
    ]
  }
}

# The SQS policy for our role
resource "aws_iam_role_policy" "sqs_policy" {
  role = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.sqs_doc.json}"
}

# We need the AWS region in order to build the log and Lambda function
# ARNs
data "aws_region" "current" {}

# We need the AWS account ID in order to build the log and Lambda
# function ARNs
data "aws_caller_identity" "current" {}

# IAM policy document that that allows some Cloudwatch permissions for
# our Lambda function.  This will allow the Lambda function to
# generate log output in Cloudwatch.  This will be applied to the role
# we are creating.
data "aws_iam_policy_document" "cloudwatch_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_function_name}",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:*"
    ]
  }
}

# The CloudWatch policy for our role
resource "aws_iam_role_policy" "cloudwatch_policy" {
  role = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.cloudwatch_doc.json}"
}

# IAM policy document that that allows the Lambda function to invoke
# itself.  This will be applied to the role we are creating.
data "aws_iam_policy_document" "lambda_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "lambda:InvokeFunction"
    ]

    resources = [
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}"
    ]
  }
}

# The Lambda policy for our role
resource "aws_iam_role_policy" "lambda_policy" {
  role = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.lambda_doc.json}"
}
