# Configure AWS
provider "aws" {
  region = "${var.aws_region}"
}

# Configure the S3 buckets
module "s3" {
  source = "./modules/s3"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
}

# Configure the IAM role
module "iam" {
  source = "./modules/iam"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
}

# Configure the SES rules
module "ses" {
  source = "./modules/ses"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
  emails = "${var.emails}"
}
