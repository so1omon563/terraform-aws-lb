resource "aws_lb_target_group" "nlb-tg" {
  for_each                           = local.nlb_type
  name                               = local.nlb_tg_name
  deregistration_delay               = var.deregistration_delay
  lambda_multi_value_headers_enabled = local.lambda_multi_value_headers_enabled
  port                               = local.port
  preserve_client_ip                 = local.preserve_client_ip
  protocol                           = local.protocol
  proxy_protocol_v2                  = var.proxy_protocol_v2
  slow_start                         = var.slow_start
  target_type                        = var.target_type
  vpc_id                             = var.vpc_id

  dynamic "health_check" {
    for_each = local.nlb_health_check_enabled
    content {
      enabled             = health_check.value
      healthy_threshold   = local.nlb_health_check.healthy_unhealthy_threshold
      interval            = local.nlb_health_check.interval
      path                = local.nlb_health_check_path
      port                = local.nlb_health_check.port
      protocol            = local.nlb_health_check.protocol
      unhealthy_threshold = local.nlb_health_check.healthy_unhealthy_threshold
    }
  }

  dynamic "stickiness" {
    for_each = local.nlb_stickiness_enabled
    content {
      enabled = stickiness.value
      type    = var.nlb_stickiness.type
    }
  }

  tags = merge({ "Name" = local.nlb_tg_name }, local.tags)
}
