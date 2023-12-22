# Cognito resources used by the Elasticsearch domain

# The Cognito user pool
resource "aws_cognito_user_pool" "dmarc" {
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  auto_verified_attributes = [
    "email",
  ]

  mfa_configuration = "ON"
  name              = var.cognito_user_pool_name
  software_token_mfa_configuration {
    enabled = true
  }
  user_attribute_update_settings {
    attributes_require_verification_before_update = [
      "email",
    ]
  }
}

# The managed Cognito user pool client for the Elasticsearch endpoint. This
# resource is used to manage the Cognito user pool client that is automatically
# created by Elasticsearch (OpenSearch) when Cognito authentication is enabled.
# Thanks to this comment for pointing me in the right direction:
# https://github.com/hashicorp/terraform-provider-aws/issues/5557#issuecomment-1015731466
resource "aws_cognito_managed_user_pool_client" "dmarc" {
  name_prefix  = "AmazonOpenSearchService-${var.cognito_user_pool_name}"
  user_pool_id = aws_cognito_user_pool.dmarc.id

  depends_on = [
    aws_elasticsearch_domain.es,
  ]
}

# The Cognito user pool domain
resource "aws_cognito_user_pool_domain" "dmarc" {
  domain       = var.cognito_user_pool_domain
  user_pool_id = aws_cognito_user_pool.dmarc.id
}
