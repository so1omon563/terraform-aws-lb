resource "aws_lb_target_group" "alb-tg" {
  for_each                           = local.alb_type
  name                               = local.alb_tg_name
  deregistration_delay               = var.deregistration_delay
  lambda_multi_value_headers_enabled = local.lambda_multi_value_headers_enabled
  port                               = local.port
  protocol_version                   = local.protocol_version
  protocol                           = local.protocol
  slow_start                         = var.slow_start
  target_type                        = var.target_type
  vpc_id                             = var.vpc_id

  dynamic "health_check" {
    for_each = local.alb_health_check_enabled
    content {
      enabled             = health_check.value
      healthy_threshold   = local.alb_health_check.healthy_threshold
      interval            = local.alb_health_check.interval
      matcher             = local.alb_health_check.matcher
      path                = local.alb_health_check_path
      port                = local.alb_health_check.port
      protocol            = local.alb_health_check_protocol
      timeout             = local.alb_health_check.timeout
      unhealthy_threshold = local.alb_health_check.unhealthy_threshold
    }
  }

  dynamic "stickiness" {
    for_each = local.alb_stickiness_enabled
    content {
      enabled         = stickiness.value
      cookie_duration = var.alb_stickiness.cookie_duration
      cookie_name     = var.alb_stickiness.cookie_name
      type            = var.alb_stickiness.type
    }
  }

  tags = merge({ "Name" = local.alb_tg_name }, local.tags)
}
