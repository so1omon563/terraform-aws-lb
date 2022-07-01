module "nlb-listener" {
  for_each = local.nlb_default_type
  source   = "./modules//lb-listener/"

  certificate_arn          = var.certificate_arn
  forward_target_group_arn = module.nlb-tg[each.key].tg.network.arn
  load_balancer_arn        = aws_lb.nlb[each.key].arn
  port                     = local.nlb_default_listener.port
  protocol                 = local.nlb_default_listener.protocol
  tags                     = merge({ "DefaultListener" = "true" }, local.tags)
}
