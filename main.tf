module "dmarc-import" {
  source = "./module"

  aws_region = "${var.aws_region}"
  queue_name = "${var.queue_name}"
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
  emails = "${var.emails}"
}
