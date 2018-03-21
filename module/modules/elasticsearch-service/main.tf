# The Elasticsearch domain
resource "aws_elasticsearch_domain" "es" {
  domain_name = "dmarc-import-elasticsearch"
  elasticsearch_version = "6.0"

  # cluster_config {
  #   instance_type = "r3.large.elasticsearch"
  # }
}
