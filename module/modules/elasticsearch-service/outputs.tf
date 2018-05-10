output "elasticsearch_arn" {
  value = "${aws_elasticsearch_domain.es.arn}"
  description = "The ARN of the Elasticsearch instance"
}

output "elasticsearch_endpoint" {
  value = "${aws_elasticsearch_domain.es.endpoint}"
  description = "The endpoint of the Elasticsearch instance"
}
