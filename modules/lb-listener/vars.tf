variable "alpn_policy" {
  description = "(Optional) Name of the Application-Layer Protocol Negotiation (ALPN) policy. Can be set if `protocol` is `TLS`. Valid values are `HTTP1Only`, `HTTP2Only`, `HTTP2Optional`, `HTTP2Preferred`, and `None`."
  type        = string
  default     = null

  validation {
    condition = var.alpn_policy != null ? contains([
      "HTTP1Only",
      "HTTP2Only",
      "HTTP2Optional",
      "HTTP2Preferred",
      "None",
    ], var.alpn_policy) : var.alpn_policy == null
    error_message = "Valid values are limited to (HTTP1Only,HTTP2Only,HTTP2Optional,HTTP2Preferred,None)."
  }
}

variable "certificate_arn" {
  type        = string
  description = "(Optional) ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS"
  default     = null
}

variable "fixed_response_content_type" {
  type        = string
  description = "(Required for listeners of `type` : `fixed_response`) Content type. Valid values are `text/plain`, `text/css`, `text/html`, `application/javascript` and `application/json`."
  default     = null

  validation {
    condition = var.fixed_response_content_type != null ? contains([
      "text/plain",
      "text/css",
      "text/html",
      "application/javascript",
      "application/json",
    ], var.fixed_response_content_type) : var.fixed_response_content_type == null
    error_message = "Valid values are limited to (text/plain,text/css,text/html,application/javascript,application/json)."
  }
}

variable "fixed_response_message_body" {
  type        = string
  description = "(Optional for listeners of `type` : `fixed_response`) Message body."
  default     = null
}

variable "fixed_response_status_code" {
  type        = string
  description = "(Optional for listeners of `type` : `fixed_response`) HTTP response code. Valid values are `2XX`, `4XX`, or `5XX`."
  default     = null

  validation {
    condition     = var.fixed_response_status_code != null ? can(regex("^[2,4,5][0-9][0-9]$", var.fixed_response_status_code)) : var.fixed_response_status_code == null
    error_message = "Valid values are limited to (2XX,4XX,5XX), where `X` is a number between 0-9."
  }
}

variable "forward_target_group_arn" {
  type        = string
  description = "(Optional) ARN of the Target Group to which to route traffic. Specify only if `type` is `forward` and you want to route to a single target group. To route to one or more target groups, use a `forward` block instead."
  default     = null
}

variable "forward_target_group_block" {
  type        = map(string)
  description = <<EOT
  (Optional) Map of up to 5 ARNs of Target Groups to which to route traffic, and their associated weight.
  Weight is a range from 0-999.
  Specify `arn` as the `key`, and `weight` as the `value`.
  Specify only if `type` is `forward` and you want to route to multiple target groups. To route to a single target groups, use `var.forward_target_group_arn` instead.

  Example:
```
  {
    arn1 : 8
    arn2 : 2
  }
```
  EOT
  default     = null
}

variable "forward_stickiness_block" {
  type        = map(string)
  description = "Map of stickiness options for the listener rule. Duration is a value in seconds between 1-604800 (7 days). See [stickiness](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#stickiness) for documentation of the options."
  default = {
    enabled  = true
    duration = 86400
  }
  validation {
    condition = (
      can(tobool(var.forward_stickiness_block.enabled))
    )
    error_message = "Valid values for `enabled` are `true` or `false."
  }
  validation {
    condition = (
      can(regex("^([1-9]|[1-9][0-9]{1,4}|[1-5][0-9]{5}|60[0-3][0-9]{3}|604[0-7][0-9]{2}|604800)$", var.forward_stickiness_block.duration))
    )
    error_message = "Valid values for `duration` are 1-604800."
  }
}

variable "load_balancer_arn" {
  type        = string
  description = "(Required, Forces New Resource) ARN of the load balancer."
}

variable "port" {
  type        = string
  description = "(Optional) Port on which the load balancer is listening. Not valid for Gateway Load Balancers."
  default     = null
}

variable "protocol" {
  type        = string
  description = "(Optional) Protocol for connections from clients to the load balancer. For Application Load Balancers, valid values are `HTTP` and `HTTPS`, with a default of `HTTP`. For Network Load Balancers, valid values are `TCP`, `TLS`, `UDP`, and `TCP_UDP`. Not valid to use `UDP` or `TCP_UDP` if dual-stack mode is enabled. Not valid for Gateway Load Balancers."
  default     = null

  validation {
    condition = var.protocol != null ? contains([
      "HTTP",
      "HTTPS",
      "TCP",
      "TCP_UDP",
      "TLS",
      "UDP",
    ], var.protocol) : var.protocol == null
    error_message = "Valid values are limited to (HTTP,HTTPS,TCP,TCP_UDP,TLS,UDP)."
  }
}

variable "redirect_host" {
  type        = string
  description = "(Optional for listeners of `type` : `redirect`) Hostname. This component is not percent-encoded. The hostname can contain `#{host}`. Defaults to `#{host}` if not specified."
  default     = null
}

variable "redirect_path" {
  type        = string
  description = "(Optional for listeners of `type` : `redirect`) Absolute path, starting with the leading '/'. This component is not percent-encoded. The path can contain `#{host}`, `#{path}`, and `#{port}`. Defaults to `/#{path} if not specified`."
  default     = null
}

variable "redirect_port" {
  type        = string
  description = "(Optional for listeners of `type` : `redirect`) Port. Specify a value from `1` to `65535` or `#{port}`. Defaults to `#{port}` if not specified."
  default     = null

  validation {
    condition     = var.redirect_port != null ? can(regex("^([1-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$", var.redirect_port)) || contains(["#{port}"], var.redirect_port) : var.redirect_port == null
    error_message = "Valid values for `redirect_port` are either ports 1-65535, or `#{port}`."
  }
}

variable "redirect_protocol" {
  type        = string
  description = "(Optional for listeners of `type` : `redirect`) Protocol. Valid values are `HTTP`, `HTTPS`, or `#{protocol}`. Defaults to `#{protocol}` if not specified."
  default     = null
}

variable "redirect_query" {
  type        = string
  description = "(Optional for listeners of `type` : `redirect`) Query parameters, URL-encoded when necessary, but not percent-encoded. Do not include the leading '?'. Defaults to `#{query}` if not specified."
  default     = null
}

variable "redirect_status_code" {
  type        = string
  description = "(Required for listeners of `type` : `redirect`) HTTP redirect code. The redirect is either permanent (`HTTP_301`) or temporary (`HTTP_302`)."
  default     = null

  validation {
    condition = var.redirect_status_code != null ? contains([
      "HTTP_301",
      "HTTP_302",
    ], var.redirect_status_code) : var.redirect_status_code == null
    error_message = "Valid values are limited to (HTTP_301,HTTP_302)."
  }
}

variable "ssl_policy" {
  type        = string
  description = "(Optional) Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tag names and values for tags to apply to all taggable resources created by the module. Default value is a blank map to allow for using Default Tags in the provider."
  default     = {}
}

variable "type" {
  type        = string
  description = "Type of routing action. Valid values are `forward`, `redirect`, `fixed-response`."
  default     = "forward"

  validation {
    condition = contains([
      "forward",
      "redirect",
      "fixed-response",
    ], var.type)
    error_message = "Valid values are limited to (forward,redirect,fixed-response)."
  }
}
