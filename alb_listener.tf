module "alb-listener" {
  for_each = local.alb_default_type
  source   = "./modules//lb-listener/"

  certificate_arn          = var.certificate_arn
  forward_target_group_arn = module.alb-tg[each.key].tg.application.arn
  load_balancer_arn        = aws_lb.alb[each.key].arn
  port                     = local.alb_default_listener.port
  protocol                 = local.alb_default_listener.protocol
  tags                     = merge({ "DefaultListener" = "true" }, local.tags)

}
