# dmarc-import-terraform :cloud: :zap: #

[![Build Status](https://travis-ci.org/dhs-ncats/dmarc-import-terraform.svg?branch=develop)](https://travis-ci.org/dhs-ncats/dmarc-import-terraform)

`dmarc-import-terraform` contains the Terraform configuration files
that build the AWS infrastrusture used for parsing DMARC aggregate
reports.  This repository goes along with
[`dmarc-import`](https://github.com/dhs-ncats/dmarc-import), which
contains the actual source code for ingesting, parsing, and saving the
DMARC aggregate reports.

## Installation of the Terraform infrastructure ##

```bash
terraform init
terraform validate -var-file=production.tfvars
terraform plan -var-file=production.tfvars
terraform apply -var-file=production.tfvars
```
## License ##

This project is in the worldwide [public domain](LICENSE.md).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
