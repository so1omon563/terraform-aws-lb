# This file is for local values that may be required for the module to run.

locals {
  tags = var.tags

  # Sets the load balancer type so for_each can be used to create them. Only care about the key here, so the value is set to "ignore"
  alb_type = var.load_balancer_type == "application" ? { application = "ignore" } : {}
  nlb_type = var.load_balancer_type == "network" ? { network = "ignore" } : {}

  alb_name = lower(var.lb_name_override != null ? var.lb_name_override : var.lb_name_random == true && var.lb_name_type == null ? format("%s-%s-alb", var.name, random_id.random.hex) : var.lb_name_random == false && var.lb_name_type != null ? format("%s-%s-alb", var.name, var.lb_name_type) : var.lb_name_random == true && var.lb_name_type != null ? format("%s-%s-%s-alb", var.name, var.lb_name_type, random_id.random.hex) : format("%s-alb", var.name))
  nlb_name = lower(var.lb_name_override != null ? var.lb_name_override : var.lb_name_random == true && var.lb_name_type == null ? format("%s-%s-nlb", var.name, random_id.random.hex) : var.lb_name_random == false && var.lb_name_type != null ? format("%s-%s-alb", var.name, var.lb_name_type) : var.lb_name_random == true && var.lb_name_type != null ? format("%s-%s-%s-alb", var.name, var.lb_name_type, random_id.random.hex) : format("%s-nlb", var.name))

  alb_defaults = {
    drop_invalid_header_fields = false
    idle_timeout               = 60
    enable_http2               = true
  }

  nlb_defaults = {
    enable_cross_zone_load_balancing = false
  }

  alb = merge(local.alb_defaults, var.alb)
  nlb = merge(local.nlb_defaults, var.nlb)

  # Sets values for default listeners / target groups
  # Sets type for for_each. Only care about the key here, so the value is set to "ignore"
  alb_default_type = var.default_listener == true && var.load_balancer_type == "application" ? { application = "ignore" } : {}
  nlb_default_type = var.default_listener == true && var.load_balancer_type == "network" ? { network = "ignore" } : {}
  # Sets port and protocol values
  alb_default_listener = var.default_listener == true && var.certificate_arn != null ? { port = 443, protocol = "HTTPS" } : { port = 80, protocol = "HTTP" }
  nlb_default_listener = var.default_listener == true && var.certificate_arn != null ? { port = 443, protocol = "TLS" } : { port = 80, protocol = "TCP" }
}
