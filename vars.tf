variable "name" {
  type        = string
  description = "Short, descriptive name of the environment. All resources will be named using this value as a prefix."
}

variable "access_logs_bucket" {
  description = "The name of the S3 bucket to log LB access to."
  type        = string
  default     = null
}

variable "access_logs_prefix" {
  description = "The S3 bucket prefix for access logs. If not configured, logs are stored in the root of the bucket."
  type        = string
  default     = null
}

variable "alb" {
  type        = map(string)
  description = <<EOT
  A map of variables for an application load balancer. Options in `local.alb_defaults` can be overridden here.
  Default values are:
```
  alb_defaults = {
    drop_invalid_header_fields = false
    idle_timeout               = 60
    enable_http2               = true
  }
```
  See [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) for more information on the options
  EOT
  default     = {}
}

variable "certificate_arn" {
  type        = string
  description = "If `default_listener` is set to `true`, this is the ARN of the SSL server certificate to use for the default listener if `HTTPS` or `TLS` is desired."
  default     = null
}

variable "customer_owned_ipv4_pool" {
  description = "The ID of the customer owned ipv4 pool to use for this load balancer."
  type        = string
  default     = null
}

variable "default_listener" {
  type        = bool
  description = "Creates a default forwarding listener and target group, based on the load balancer type. If a `certificate_arn` value is provided, the listener will be `HTTPS` or `TLS`, otherwise it will be `HTTP` or `TCP`."
  default     = true
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to `false`."
  type        = bool
  default     = false
}

variable "internal" {
  description = "If true, the LB will be internal. Defaults to `false`."
  type        = bool
  default     = false
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`. Internal LBs can only use `ipv4`. You can only use `dualstack` if the selected subnets are IPv6 enabled."
  type        = string
  default     = "ipv4"

  validation {
    condition = contains([
      "ipv4",
      "dualstack",
    ], var.ip_address_type)
    error_message = "Valid values are limited to (ipv4,dualstack)."
  }
}

variable "lb_name_override" {
  type        = string
  description = "Used if there is a need to specify a LB name outside of the standardized nomenclature. For example, if importing a load ballancer that doesn't follow the standard naming formats."
  default     = null
}

variable "lb_name_type" {
  type        = string
  description = "If there are multiple of the same type of LB in an environment, adding a type descriptor here (web, app, internal, etc) will add it to the `name` of the LB."
  default     = null
}

variable "lb_name_random" {
  type        = bool
  description = "If there are multiple of the same type of LB in an environment, setting this as `true` will add a random hex to the `name` of the LB."
  default     = false
}

# This variable only allows `application` and `network` at this time.
# Once GLB support is added in to the module, `gateway` will be added as an accepted value.
# TODO - Update variable to accept `gateway` once GLB support is added.
variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are `application` or `network`. The default value is `application`."
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

variable "nlb" {
  type        = map(string)
  description = <<EOT
  A map of variables for a network load balancer. Options in `local.nlb_defaults` can be overridden here.
  Default values are:
```
  nlb_defaults = {
    enable_cross_zone_load_balancing = false
  }
```
  See [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) for more information on the options
  EOT
  default     = {}
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs to attach to the LB. Please note that updating subnets for Load Balancers of type `network` will force a recreation of the resource."
}

variable "security_groups" {
  type        = list(string)
  description = "List of Security Group IDs to attach to the LB. Only valid for Load Balancers of type `application`."
  default     = []
}

variable "target_type" {
  description = "If `default_listener` is set to `true`, this is the type of target that you must specify when registering targets with the default target group. The possible values are `instance` (targets are specified by instance ID) or `ip` (targets are specified by IP address) or `lambda` (targets are specified by lambda arn). The default is `instance`. Note that you can't specify targets for a target group using both instance IDs and IP addresses. If the target type is `ip`, specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group, the RFC 1918 range (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16), and the RFC 6598 range (100.64.0.0/10). You can't specify publicly routable IP addresses."
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

variable "tags" {
  type        = map(string)
  description = "A map of tag names and values for tags to apply to all taggable resources created by the module. Default value is a blank map to allow for using Default Tags in the provider."
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC these resources should be added to."
}
