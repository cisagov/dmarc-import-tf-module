# The Elasticsearch domain
resource "aws_elasticsearch_domain" "es" {
  domain_name = "${var.elasticsearch_domain_name}"
  elasticsearch_version = "6.2"

  cluster_config = {
    instance_type = "m4.large.elasticsearch"
    instance_count = 1
  }

  ebs_options = {
    ebs_enabled = true
    volume_type = "standard"
    volume_size = 100
  }

  encrypt_at_rest = {
    enabled = true
  }

  tags = "${var.tags}"
}
