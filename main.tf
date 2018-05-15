module "dmarc-import" {
  source = "./module"

  aws_region = "${var.aws_region}"
  queue_name = "${var.queue_name}"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
  emails = "${var.emails}"
  lambda_function_name = "${var.lambda_function_name}"
  lambda_function_zip_file = "${var.lambda_function_zip_file}"
  elasticsearch_index = "${var.elasticsearch_index}"
  elasticsearch_type = "${var.elasticsearch_type}"
  elasticsearch_domain_name = "${var.elasticsearch_domain_name}"
  tags = "${var.tags}"
}
