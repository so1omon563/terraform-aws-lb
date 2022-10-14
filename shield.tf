resource "aws_shield_protection" "alb" {
  count        = var.load_balancer_type == "application" && var.shield_advanced_protection ? 1 : 0
  name         = aws_lb.alb["application"].name
  resource_arn = aws_lb.alb["application"].arn

  tags = local.tags
}
