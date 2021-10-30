# ALB [東京リージョン]
resource "aws_wafv2_web_acl" "alb" {
  name  = "${local.service_config.prefix}-alb"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "allow-cloudfront-custom-header"
    priority = 1

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        positional_constraint = "CONTAINS"
        search_string         = "${local.service_config.prefix}-cloudfront"

        field_to_match {
          single_header {
            name = "cloudfront-custom-header"
          }
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      metric_name                = "allow-cloudfront-custom-header"
      cloudwatch_metrics_enabled = false
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    metric_name                = "alb"
    cloudwatch_metrics_enabled = false
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${local.service_config.prefix}-web-acl-alb"
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_alb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.alb.arn
}
