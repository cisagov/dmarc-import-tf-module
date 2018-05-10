variable "domain_name" {
  type = "string"
  description = "The domain name to use for this Elasticsearch instance"
}

variable "tags" {
  type = "map"
  default = {}
  description = "Tags to apply to all AWS resources created"
}
