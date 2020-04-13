# dmarc-import-terraform #

[![GitHub Build Status](https://github.com/cisagov/dmarc-import-tf-module/workflows/build/badge.svg)](https://github.com/cisagov/dmarc-import-tf-module/actions)

`dmarc-import-terraform` contains the Terraform configuration files to
build the AWS infrastructure used for parsing DMARC aggregate reports.
This repository goes along with
[`dmarc-import`](https://github.com/cisagov/dmarc-import), which
contains the actual source code for ingesting, parsing, and saving the
DMARC aggregate reports.

Here is a [Cloudcraft.co](https://cloudcraft.co) diagram of the basic
infrastructure created by these Terraform files:
![diagram](dmarc_import.svg)

## Usage ##

```hcl
module "dmarc_import" {
  source = "github.com/cisagov/dmarc-import-tf-module"

  providers = {
    aws = aws.dnsprovisionaccount
  }

  aws_region                = var.aws_region
  elasticsearch_domain_name = var.elasticsearch_domain_name
  elasticsearch_index       = var.elasticsearch_index
  elasticsearch_type        = var.elasticsearch_type
  emails                    = var.emails
  lambda_function_name      = var.lambda_function_name
  lambda_function_zip_file  = var.lambda_function_zip_file
  permanent_bucket_name     = var.permanent_bucket_name
  queue_name                = var.queue_name
  rule_set_name             = var.rule_set_name
  tags                      = var.tags
  temporary_bucket_name     = var.temporary_bucket_name
}
```

## Examples ##

No examples.

## Providers ##

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| aws_region | The AWS region to deploy into (e.g. us-east-1). | `string` | `us-east-1` | no |
| elasticsearch_domain_name | The domain name of the Elasticsearch instance. | `string` | n/a | yes |
| elasticsearch_index | The Elasticsearch index to which to write DMARC aggregate report data. | `string` | n/a | yes |
| elasticsearch_type | The Elasticsearch type corresponding to a DMARC aggregate report. | `string` | n/a | yes |
| emails | A list of the email addresses at which DMARC aggregate reports are being received. | `list(string)` | n/a | yes |
| lambda_function_name | The name to use for the Lambda function. | `string` | n/a | yes |
| lambda_function_zip_file | The location of the zip file for the Lambda function. | `string` | n/a | yes |
| permanent_bucket_name | The name of the S3 bucket where the DMARC aggregate report emails are stored permanently. | `string` | n/a | yes |
| queue_name | The name of the SQS queue where events will be sent as DMARC aggregate reports are received. | `string` | n/a | yes |
| rule_set_name | The name of the SES rule set that processes DMARC aggregate reports. | `string` | n/a | yes |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| temporary_bucket_name | The name of the S3 bucket where the DMARC aggregate report emails are stored temporarily (until processed). | `string` | n/a | yes |

## Outputs ##

No output.

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, these are the main directory and
every directory under `examples/`.

## Contributing ##

We welcome contributions!  Please see [here](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
