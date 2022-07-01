module "nlb-tg" {
  for_each = local.nlb_default_type
  source   = "./modules//lb-target-group/"

  name               = format("%s-def", var.name)
  load_balancer_type = each.key
  port               = local.nlb_default_listener.port
  protocol           = local.nlb_default_listener.protocol
  tags               = merge({ "DefaultTargetGroup" = "true" }, local.tags)
  target_type        = var.target_type
  vpc_id             = var.vpc_id
}
