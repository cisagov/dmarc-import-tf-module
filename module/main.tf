provider "aws" {
  region = "${var.aws_region}"
}

module "s3" {
  source = "./modules/s3"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
}
