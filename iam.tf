# IAM assume role policy document for the role we're creating
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# The role we're creating
resource "aws_iam_role" "lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# IAM policy document that that allows some S3 permissions on our
# temporary dmarc-import bucket.  This will be applied to the role we
# are creating.
data "aws_iam_policy_document" "s3_lambda" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.temporary.arn}/*",
    ]
  }
}

# The S3 policy for our role
resource "aws_iam_role_policy" "s3_lambda" {
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.s3_lambda.json
}

# IAM policy document that allows HEADing, POSTing, and PUTting to
# Elasticsearch.  This will be applied to the role we are creating.
data "aws_iam_policy_document" "es_lambda" {
  statement {
    effect = "Allow"

    actions = [
      "es:ESHttpHead",
      "es:ESHttpPost",
      "es:ESHttpPut",
    ]

    resources = [
      aws_elasticsearch_domain.es.arn,
      "${aws_elasticsearch_domain.es.arn}/*",
    ]
  }
}

# The Elasticsearch policy for our role
resource "aws_iam_role_policy" "es_policy" {
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.es_lambda.json
}

# IAM policy document that that allows some SQS permissions on our
# dmarc-import queue.  This will be applied to the role we are
# creating.
data "aws_iam_policy_document" "sqs_lambda" {
  statement {
    effect = "Allow"

    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
    ]

    resources = [
      aws_sqs_queue.dmarc_reports.arn,
    ]
  }
}

# The SQS policy for our role
resource "aws_iam_role_policy" "sqs_policy" {
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.sqs_lambda.json
}

# IAM policy document that that allows some Cloudwatch permissions for
# our Lambda function.  This will allow the Lambda function to
# generate log output in Cloudwatch.  This will be applied to the role
# we are creating.
data "aws_iam_policy_document" "cloudwatch_lambda" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.logs.arn,
    ]
  }
}

# The CloudWatch policy for our role
resource "aws_iam_role_policy" "cloudwatch_policy" {
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.cloudwatch_lambda.json
}

# IAM policy document that that allows the Lambda function to invoke
# itself.  This will be applied to the role we are creating.
data "aws_iam_policy_document" "lambda_lambda" {
  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      aws_lambda_function.lambda.arn,
    ]
  }
}

# The Lambda policy for our role
resource "aws_iam_role_policy" "lambda_lambda" {
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_lambda.json
}
