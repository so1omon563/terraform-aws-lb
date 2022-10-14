resource "aws_wafv2_web_acl_association" "alb" {
  for_each     = toset(var.wafv2_acl_arns)
  resource_arn = aws_lb.alb["application"].arn
  web_acl_arn  = each.key
}
