data "aws_cloudfront_cache_policy" "cachingOptimized" {
    name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "cachingDisabled" {
    name = "Managed-CachingDisabled"
}

data "aws_ssm_parameter" "certificate_arn" {
    name = "/${var.project}/${var.environment}/certificate_arn"
}

