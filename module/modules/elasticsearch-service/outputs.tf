output "elasticsearch_arn" {
  value = "${aws_elasticsearch_domain.es.arn}"
  description = "The ARN of the Elasticsearch instance"
}
