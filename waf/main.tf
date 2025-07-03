provider "aws" {
  region = "us-east-1"
}

resource "aws_wafv2_web_acl" "geo_block_acl" {
  name        = "geo-block-acl"
  description = "Block traffic from specified countries"
  scope       = "REGIONAL"  # Use "CLOUDFRONT" for global distributions

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "GeoBlockACL"
    sampled_requests_enabled   = true
  }

  dynamic "rule" {
    for_each = length(var.blocked_countries) > 0 ? [1] : []

    content {
      name     = "GeoBlockRule"
      priority = 1

      action {
        block {}
      }

      statement {
        geo_match_statement {
          country_codes = var.blocked_countries
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "GeoBlockRule"
        sampled_requests_enabled   = true
      }
    }
  }

  tags = {
    Environment = "Dev"
    Name        = "GeoBlockACL"
  }
}
