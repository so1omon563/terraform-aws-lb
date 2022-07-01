# This file is for local values that may be required for the module to run.

locals {
  tags = var.tags

  ssl_policy = var.ssl_policy != null && var.certificate_arn == null ? null : var.ssl_policy == null && var.certificate_arn != null ? "ELBSecurityPolicy-TLS-1-2-Ext-2018-06" : var.ssl_policy == null && var.certificate_arn == null ? null : var.ssl_policy != null && var.certificate_arn != null ? var.ssl_policy : "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  # For using for_each to handle dynamic blocks
  forward            = var.forward_target_group_block != null ? { forward = "ignored_value" } : {}
  target_group_block = var.forward_target_group_block != null ? var.forward_target_group_block : {}
  stickiness_enabled = tobool(var.forward_stickiness_block.enabled) == true ? { enabled = true } : {}
  fixed_response     = var.fixed_response_content_type != null ? { content_type = var.fixed_response_content_type } : {}
  redirect           = var.redirect_status_code != null ? { status_code = var.redirect_status_code } : {}
}
