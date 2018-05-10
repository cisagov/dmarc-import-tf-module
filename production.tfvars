aws_region = "us-east-1"

queue_name = "dmarc-import-queue"

permanent_bucket_name = "dmarc-import-permanent"

temporary_bucket_name = "dmarc-import-temporary"

emails = [
  "reports@dmarc.cyber.dhs.gov",
  "reports@dmarc.cyber.secure-fed.org"
]

lambda_function_name = "dmarc-import"

lambda_function_zip_file = "../dmarc-import-lambda/dmarc-import.zip"

elasticsearch_index = "dmarc_aggregate_reports"

elasticsearch_domain_name = "dmarc-import-elasticsearch"
