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
      "${aws_s3_bucket.temporary.arn}/*"
    ]
  }
}

# The S3 policy for our role
resource "aws_iam_role_policy" "s3_policy" {
  role = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.s3_doc.json}"
}

# IAM policy document that that allows POSTing to Elasticsearch.  This
# will be applied to the role we are creating.
data "aws_iam_policy_document" "es_doc" {
  statement {
    effect = "Allow"
    
    actions = [
      "es:ESHttpPost"
    ]
    
    resources = [
      "${aws_elasticsearch_domain.es.arn}",
      "${aws_elasticsearch_domain.es.arn}/*"
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
      "${aws_sqs_queue.queue.arn}"
    ]
  }
}

# The SQS policy for our role
resource "aws_iam_role_policy" "sqs_policy" {
  role = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.sqs_doc.json}"
}

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
      "${aws_cloudwatch_log_group.logs.arn}",
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
      "${aws_lambda_function.lambda.arn}"
    ]
  }
}

# The Lambda policy for our role
resource "aws_iam_role_policy" "lambda_policy" {
  role = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.lambda_doc.json}"
}
