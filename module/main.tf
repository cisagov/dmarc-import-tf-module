# Configure the SQS queue
module "sqs" {
  source = "./modules/sqs"
  queue_name = "${var.queue_name}"
  tags = "${var.tags}"
}

# Configure the S3 buckets
module "s3" {
  source = "./modules/s3"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
  queue_arn = "${module.sqs.queue_arn}"
  tags = "${var.tags}"
}

# Configure the IAM role
module "iam" {
  source = "./modules/iam"
  temporary_bucket_arn = "${module.s3.temporary_bucket_arn}"
  queue_arn = "${module.sqs.queue_arn}"
  elasticsearch_arn = "${module.elasticsearch-service.elasticsearch_arn}"
  lambda_function_name = "${var.lambda_function_name}"
  tags = "${var.tags}"
}

# Configure the SES rules
module "ses" {
  source = "./modules/ses"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
  emails = "${var.emails}"
  tags = "${var.tags}"
}

# Configure Elasticsearch
module "elasticsearch-service" {
  source = "./modules/elasticsearch-service"
  domain_name = "${var.elasticsearch_domain_name}"
  tags = "${var.tags}"
}

# Configure the Lambda function
module "lambda" {
  source = "./modules/lambda"
  name = "${var.lambda_function_name}"
  zip_file = "${var.lambda_function_zip_file}"
  role_arn = "${module.iam.role_arn}"
  queue_url = "${module.sqs.queue_url}"
  elasticsearch_endpoint = "${module.elasticsearch-service.elasticsearch_endpoint}"
  elasticsearch_index = "${var.elasticsearch_index}"
  elasticsearch_type = "${var.elasticsearch_type}"
  tags = "${var.tags}"
}
