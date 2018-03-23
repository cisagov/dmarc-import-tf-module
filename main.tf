module "dmarc-import" {
  source = "./module"

  aws_region = "${var.aws_region}"
  bucket_prefix = "${var.bucket_prefix}"
  emails = "${var.emails}"
}
