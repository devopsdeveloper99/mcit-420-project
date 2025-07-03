output "web_acl_arn" {
  description = "The ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.geo_block_acl.arn
}

output "web_acl_name" {
  description = "The name of the WAF Web ACL"
  value       = aws_wafv2_web_acl.geo_block_acl.name
}
