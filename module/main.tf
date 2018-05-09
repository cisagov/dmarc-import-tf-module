# Configure AWS
provider "aws" {
  region = "${var.aws_region}"
}

# Configure the SQS queue
module "sqs" {
  source = "./modules/sqs"
  queue_name = "${var.queue_name}"
}

# Configure the S3 buckets
module "s3" {
  source = "./modules/s3"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
  queue_arn = "${module.sqs.queue_arn}"
}

# Configure the IAM role
module "iam" {
  source = "./modules/iam"
  temporary_bucket_name = "${var.temporary_bucket_name}"
  queue_arn = "${module.sqs.queue_arn}"
  elasticsearch_arn = "${module.elasticsearch-service.elasticsearch_arn}"
}

# Configure the SES rules
module "ses" {
  source = "./modules/ses"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
  emails = "${var.emails}"
}

# Configure Elasticsearch
module "elasticsearch-service" {
  source = "./modules/elasticsearch-service"
}

# Configure the Lambda function
module "lambda" {
  source = "./modules/lambda"
  name = "${var.lambda_function_name}"
  zip_file = "${var.lambda_function_zip_file}"
  role_arn = "${module.iam.role_arn}"
}
