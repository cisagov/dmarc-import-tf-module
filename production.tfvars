aws_region = "us-east-1"

queue_name = "dmarc-import-queue"

permanent_bucket_name = "dmarc-import-permanent"

temporary_bucket_name = "dmarc-import-temporary"

emails = [
  "reports@dmarc.cyber.dhs.gov"
]

lambda_function_name = "dmarc-import"

lambda_function_zip_file = "../dmarc-import-lambda/dmarc-import.zip"

elasticsearch_index = "dmarc_aggregate_reports"

elasticsearch_type = "report"

elasticsearch_domain_name = "dmarc-import-elasticsearch"

cognito_identity_pool_id = "us-east-1:33b8b144-e2e5-43c7-853d-0f3760068edc"

cognito_user_pool_id = "us-east-1_dXlTwH4Y7"

cognito_role_arn = "arn:aws:iam::344440683180:role/service-role/CognitoAccessForAmazonES"

tags = {
  Team = "NCATS OIS - Development"
  Application = "dmarc-import"
}
