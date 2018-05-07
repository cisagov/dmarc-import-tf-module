# The Elasticsearch domain
resource "aws_elasticsearch_domain" "es" {
  domain_name = "dmarc-import-elasticsearch"
  elasticsearch_version = "6.2"
}
