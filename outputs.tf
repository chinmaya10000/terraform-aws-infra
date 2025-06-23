output "cloudfront_url" {
  description = "Your HTTPS website URL"
  value       = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}
