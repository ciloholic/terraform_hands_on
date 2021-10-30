resource "aws_cloudfront_distribution" "example" {
  http_version    = "http2"
  price_class     = "PriceClass_200" # Use U.S., Canada, Europe, Asia, Middle East and Africa
  is_ipv6_enabled = true
  enabled         = true

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # ALB
  origin {
    origin_id   = "alb"
    domain_name = aws_alb.alb.dns_name

    custom_header {
      name  = "cloudfront-custom-header"
      value = "${local.service_config.prefix}-cloudfront"
    }

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1.2"]
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
    }
  }

  # ALB
  default_cache_behavior {
    target_origin_id       = "alb"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true

    forwarded_values {
      headers      = ["Authorization", "Host"]
      query_string = true

      cookies {
        forward           = "whitelist"
        whitelisted_names = ["_session_id"]
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "${local.service_config.prefix}-cloudfront"
  }
}
