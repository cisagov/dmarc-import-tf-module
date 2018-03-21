module "dmarc-import" {
  source = "./module"
  
  permanent_bucket_name = "${var.permanent_bucket_name}"
  temporary_bucket_name = "${var.temporary_bucket_name}"
  emails = "${var.emails}"
}
