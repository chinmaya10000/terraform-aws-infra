provider "aws" {
  region = "us-east-2"
}

resource "random_id" "suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "website_bucket" {
  bucket        = "my-static-site-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload files using null_resource + local-exec
resource "null_resource" "upload_files" {
  provisioner "local-exec" {
    command = <<EOT
       aws s3 cp index.html s3://${aws_s3_bucket.website_bucket.bucket}/index.html
       aws s3 cp error.html s3://${aws_s3_bucket.website_bucket.bucket}/error.html
    EOT
  }
  depends_on = [aws_s3_bucket_public_access_block.block]
}

# Origin Access Control (OAC) for CloudFront
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "S3-OAC-StaticSite"
  description                       = "OAC for secure S3 access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "S3Origin"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/error.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/error.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "SecureStaticSite"
  }

  depends_on = [aws_cloudfront_origin_access_control.oac]
}

# S3 Bucket Policy to allow CloudFront only
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.website_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
}