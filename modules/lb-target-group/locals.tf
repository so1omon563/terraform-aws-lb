# This file is for local values that may be required for the module to run.

locals {
  tags = var.tags

  alb_tg_name = lower(var.tg_name_override != null ? var.tg_name_override : var.port != null && var.protocol == null ? format("%s-%s-alb", var.name, var.port) : var.port == null && var.protocol != null ? format("%s-%s-alb", var.name, var.protocol) : var.port != null && var.protocol != null ? format("%s-%s-%s-alb", var.name, var.port, var.protocol) : format("%s-alb-tg", var.name))
  nlb_tg_name = lower(var.tg_name_override != null ? var.tg_name_override : var.port != null && var.protocol == null ? format("%s-%s-nlb", var.name, var.port) : var.port == null && var.protocol != null ? format("%s-%s-nlb", var.name, var.protocol) : var.port != null && var.protocol != null ? format("%s-%s-%s-nlb", var.name, var.port, var.protocol) : format("%s-nlb-tg", var.name))

  # Sets the load balancer type so for_each can be used to create the appropriate resources. Only care about the key here, so the value is set to "ignore"
  alb_type = var.load_balancer_type == "application" ? { application = "ignore" } : {}
  nlb_type = var.load_balancer_type == "network" ? { network = "ignore" } : {}


  alb_health_check_defaults = {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher             = null
    path                = null
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }

  alb_health_check = merge(local.alb_health_check_defaults, var.alb_health_check)

  nlb_health_check_defaults = {
    enabled                     = true
    healthy_unhealthy_threshold = 3
    interval                    = 30
    path                        = null
    port                        = "traffic-port"
    protocol                    = "TCP"
  }

  nlb_health_check = merge(local.nlb_health_check_defaults, var.nlb_health_check)

  # TODO - some of these values may be able to be grouped into maps

  # For using for_each to handle stickiness and health_check values
  alb_stickiness_enabled   = tobool(var.alb_stickiness.enabled) == true ? { enabled = true } : {}
  nlb_stickiness_enabled   = tobool(var.nlb_stickiness.enabled) == true && var.protocol != "TLS" ? { enabled = true } : {}
  alb_health_check_enabled = tobool(local.alb_health_check.enabled) == true ? { enabled = true } : {}
  nlb_health_check_enabled = tobool(local.nlb_health_check.enabled) == true ? { enabled = true } : {}


  # Using these locals forces the resources to ignore these values if `target_type` is `lambda`.
  port                      = var.target_type == "lambda" ? null : var.port
  alb_health_check_protocol = var.target_type == "lambda" ? null : local.alb_health_check.protocol
  protocol                  = var.target_type == "lambda" ? null : var.protocol
  vpc_id                    = var.target_type == "lambda" ? null : var.vpc_id

  # Using these locals forces the resources to ignore these values unless `target_type` is `lambda`.
  lambda_multi_value_headers_enabled = var.target_type == "lambda" ? var.lambda_multi_value_headers_enabled : null

  # Using these locals forces the value to only be used if the protocol is appropriate for it.
  protocol_version      = var.protocol == "HTTP" || var.protocol == "HTTPS" ? var.protocol_version : null
  preserve_client_ip    = var.target_type == "ip" && var.protocol == "TCP" || var.target_type == "ip" && var.protocol == "TLS" ? false : var.target_type == "ip" && var.protocol == "UDP" || var.target_type == "ip" && var.protocol == "TCP_UDP" ? true : var.preserve_client_ip
  alb_health_check_path = var.protocol == "HTTP" || var.protocol == "HTTPS" ? local.alb_health_check.path : null
  nlb_health_check_path = var.protocol == "HTTP" ? local.nlb_health_check.path : null
}
