variable "name" {
  type        = string
  description = "Short, descriptive name of the environment. All resources will be named using this vaule as a prefix."
}

variable "alb_health_check" {
  type        = map(string)
  description = <<EOT
  Map of health check options for ALBs. Options that have associated validations have defaults here. All other options in `local.alb_health_check_defaults` can be overridden here.
  If overriding, you MUST include values for `enabled` and `port` in addition to overrides for the other default values.
  Default values are:
```
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
```
  See [health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check) for documentation of the options.
  EOT

  default = {
    enabled = true
    port    = "traffic-port"
  }

  validation {
    condition = (
      can(tobool(var.alb_health_check.enabled))
    )
    error_message = "Valid values for `enabled` are `true` or `false."
  }
  validation {
    condition = (
      can(regex("^([1-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$", var.alb_health_check.port)) || contains(["traffic-port"], var.alb_health_check.port)
    )
    error_message = "Valid values for `port` are either ports 1-65535, or `traffic-port`."
  }
}

variable "alb_stickiness" {
  type        = map(string)
  description = "Map of stickiness options for ALBs. In order to override, you will need to populate all appropriate options. See [stickiness](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#stickiness) for documentation of the options."
  default = {
    enabled         = true
    cookie_duration = 86400
    cookie_name     = null
    type            = "lb_cookie"
  }
  validation {
    condition = (
      can(tobool(var.alb_stickiness.enabled))
    )
    error_message = "Valid values for `enabled` are `true` or `false."
  }
  validation {
    condition = contains([
      "lb_cookie",
      "app_cookie",
    ], var.alb_stickiness.type)
    error_message = "Valid values for `type` are limited to (lb_cookie,app_cookie)."
  }
  validation {
    condition = (
      can(regex("^([1-9]|[1-9][0-9]{1,4}|[1-5][0-9]{5}|60[0-3][0-9]{3}|604[0-7][0-9]{2}|604800)$", var.alb_stickiness.cookie_duration))
    )
    error_message = "Valid values for `cookie_duration` are 1-604800."
  }
}

variable "deregistration_delay" {
  type        = string
  description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds."
  default     = 300
}

variable "lambda_multi_value_headers_enabled" {
  type        = bool
  description = "Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when `target_type` is `lambda`. Default is `false`."
  default     = false
}

# This variable only allows `application` and `network` at this time.
# Once GLB support is added in to the module, `gateway` will be added as an accepted value.
# TODO - Update variable to accept `gateway` once GLB support is added.
variable "load_balancer_type" {
  description = "The type of load balancer the target group is going to be attached to. Possible values are `application` or `network`. The default value is `application`."
  type        = string
  default     = "application"

  validation {
    condition = contains([
      "application",
      "network",
    ], var.load_balancer_type)
    error_message = "Valid values are limited to (application,network)."
  }
}

variable "load_balancing_algorithm_type" {
  type        = string
  description = "Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. The value is `round_robin` or `least_outstanding_requests`. The default is `round_robin`."
  default     = "round_robin"

  validation {
    condition = contains([
      "round_robin",
      "least_outstanding_requests",
    ], var.load_balancing_algorithm_type)
    error_message = "Valid values are limited to (round_robin,least_outstanding_requests)."
  }
}

variable "nlb_health_check" {
  type        = map(string)
  description = <<EOT
  Map of health check options for NLBs. Options that have associated validations have defaults here. All other options in `local.nlb_health_check_defaults` can be overridden here.
  Default values are:
```
  nlb_health_check_defaults = {
    enabled                     = true
    healthy_unhealthy_threshold = 3
    interval                    = 30
    path                        = null
    port                        = "traffic-port"
    protocol                    = "TCP"
  }
```
  See [health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check) for documentation of the options.
  EOT

  default = {
    enabled = true
    port    = "traffic-port"
  }
  validation {
    condition = (
      can(tobool(var.nlb_health_check.enabled))
    )
    error_message = "Valid values for `enabled` are `true` or `false."
  }
  validation {
    condition = (
      can(regex("^([1-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$", var.nlb_health_check.port)) || contains(["traffic-port"], var.nlb_health_check.port)
    )
    error_message = "Valid values are either ports 1-65535, or `traffic-port`."
  }
}

variable "nlb_stickiness" {
  type        = map(string)
  description = "Map of stickiness options for NLBs. In order to override, you will need to populate all appropriate options. See [stickiness](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#stickiness) for documentation of the options."
  default = {
    enabled = true
    type    = "source_ip"
  }
  validation {
    condition = contains([
      "true",
      "false",
    ], var.nlb_stickiness.enabled)
    error_message = "Valid values are limited to (true,false)."
  }
  validation {
    condition = contains([
      "source_ip",
    ], var.nlb_stickiness.type)
    error_message = "Valid values are limited to (source_ip)."
  }
}

variable "preserve_client_ip" {
  type        = bool
  description = "(Optional) Whether client IP preservation is enabled. See [doc](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#client-ip-preservation) for more information."
  default     = true
}

variable "port" {
  type        = string
  description = "(May be required, Forces new resource) Port on which targets receive traffic, unless overridden when registering a specific target. Required when `target_type` is `instance` or `ip`. Does not apply when `target_type` is `lambda`."
  default     = null
}

# TODO - Update variable to accept `GENEVE` once GLB support is added.
variable "protocol" {
  type        = string
  description = "(May be required, Forces new resource) Protocol to use for routing traffic to the targets. Should be one of `HTTP`, `HTTPS`, `TCP`, `TCP_UDP`, `TLS`, or `UDP`. Required when `target_type` is `instance` or `ip`. Does not apply when `target_type` is `lambda`."
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

variable "protocol_version" {
  type        = string
  description = "(Optional, Forces new resource) Only applicable when protocol is `HTTP` or `HTTPS`. The protocol version. Specify `GRPC` to send requests to targets using gRPC. Specify `HTTP2` to send requests to targets using HTTP/2. The default is `HTTP1`, which sends requests to targets using HTTP/1.1"
  default     = "HTTP1"

  validation {
    condition = contains([
      "GRPC",
      "HTTP1",
      "HTTP2",
    ], var.protocol_version)
    error_message = "Valid values are limited to (GRPC,HTTP1,HTTP2)."
  }
}

variable "proxy_protocol_v2" {
  type        = bool
  description = "Whether to enable support for proxy protocol v2 on Network Load Balancers. See [doc](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#proxy-protocol) for more information. Default is `false`."
  default     = false
}

# TODO - Add variable validation for `slow_start` values
variable "slow_start" {
  type        = string
  description = "Amount of time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds."
  default     = 0
}

variable "tags" {
  type        = map(string)
  description = "A map of tag names and values for tags to apply to all taggable resources created by the module. Default value is a blank map to allow for using Default Tags in the provider."
  default     = {}
}

variable "target_type" {
  description = "(May be required, Forces new resource) Type of target that you must specify when registering targets with this target group. The possible values are `instance` (targets are specified by instance ID) or `ip` (targets are specified by IP address) or `lambda` (targets are specified by lambda arn). The default is `instance`. Note that you can't specify targets for a target group using both instance IDs and IP addresses. If the target type is `ip`, specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group, the RFC 1918 range (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16), and the RFC 6598 range (100.64.0.0/10). You can't specify publicly routable IP addresses."
  type        = string
  default     = "instance"

  validation {
    condition = contains([
      "instance",
      "ip",
      "lambda",
    ], var.target_type)
    error_message = "Valid values are limited to (instance,ip,lambda)."
  }
}

variable "tg_name_override" {
  description = "Used if there is a need to specify a target group name outside of the standardized nomenclature. For example, if importing a target group that doesn't follow the standard naming formats."
  type        = string
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "Identifier of the VPC in which to create the target group. Required when target_type is `instance` or `ip`. Does not apply when target_type is `lambda`."
  default     = null
}
