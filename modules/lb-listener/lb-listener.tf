resource "aws_lb_listener" "listener" {
  #checkov:skip=CKV_AWS_2:"Ensure ALB protocol is HTTPS" - Since this is a re-usable module, this needs to be able to be overridden.
  #checkov:skip=CKV_AWS_103:"Ensure that load balancer is using TLS 1.2" - Since this is a re-usable module, this needs to be able to be overridden.

  alpn_policy       = var.alpn_policy
  certificate_arn   = var.protocol == "HTTPS" || var.protocol == "TLS" ? var.certificate_arn : null
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  #tfsec:ignore:AWS004 - This needs to be able to use HTTP by design.
  protocol = var.protocol
  #tfsec:ignore:AWS010 - This needs to be able to use provided SSL policy. Secure policy defined in locals.tf
  ssl_policy = var.protocol == "HTTPS" || var.protocol == "TLS" ? local.ssl_policy : null


  default_action {
    type             = var.type
    target_group_arn = var.forward_target_group_arn

    dynamic "forward" {
      for_each = local.forward
      content {
        dynamic "target_group" {
          for_each = local.target_group_block
          content {
            arn    = target_group.key
            weight = target_group.value
          }
        }
        dynamic "stickiness" {
          for_each = local.stickiness_enabled
          content {
            enabled  = stickiness.value
            duration = var.forward_stickiness_block.duration
          }
        }
      }
    }

    dynamic "fixed_response" {
      for_each = local.fixed_response
      content {
        content_type = fixed_response.value
        message_body = var.fixed_response_message_body
        status_code  = var.fixed_response_status_code
      }
    }

    dynamic "redirect" {
      for_each = local.redirect
      content {
        status_code = redirect.value
        host        = var.redirect_host
        path        = var.redirect_path
        port        = var.redirect_port
        protocol    = var.redirect_protocol
        query       = var.redirect_query
      }
    }
  }

  tags = local.tags

}
