# Target Group

This submodule creates a Target Group that can be attached to a [Listener](../lb-listener).

The module supports Target Groups for both Network and Application Load Balancers. It uses the Load Balancer type to determine some sane defaults / guardrails to make sure only valid information for the LB type is passed in.

It does NOT support Gateway Load Balancers at this time.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Auto-generated technical documentation is created using [`terraform-docs`](https://terraform-docs.io/)
## Examples

```hcl
# See examples under the top level examples directory for more information on how to use this module.
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.35.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb_target_group.alb-tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.nlb-tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_health_check"></a> [alb\_health\_check](#input\_alb\_health\_check) | Map of health check options for ALBs. Options that have associated validations have defaults here. All other options in `local.alb_health_check_defaults` can be overridden here.<br>  If overriding, you MUST include values for `enabled` and `port` in addition to overrides for the other default values.<br>  Default values are:<pre>alb_health_check_defaults = {<br>    enabled             = true<br>    healthy_threshold   = 3<br>    interval            = 30<br>    matcher             = null<br>    path                = null<br>    port                = "traffic-port"<br>    protocol            = "HTTP"<br>    timeout             = 5<br>    unhealthy_threshold = 3<br>  }</pre>See [health\_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check) for documentation of the options. | `map(string)` | <pre>{<br>  "enabled": true,<br>  "port": "traffic-port"<br>}</pre> | no |
| <a name="input_alb_stickiness"></a> [alb\_stickiness](#input\_alb\_stickiness) | Map of stickiness options for ALBs. In order to override, you will need to populate all appropriate options. See [stickiness](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#stickiness) for documentation of the options. | `map(string)` | <pre>{<br>  "cookie_duration": 86400,<br>  "cookie_name": null,<br>  "enabled": true,<br>  "type": "lb_cookie"<br>}</pre> | no |
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds. | `string` | `300` | no |
| <a name="input_lambda_multi_value_headers_enabled"></a> [lambda\_multi\_value\_headers\_enabled](#input\_lambda\_multi\_value\_headers\_enabled) | Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when `target_type` is `lambda`. Default is `false`. | `bool` | `false` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of load balancer the target group is going to be attached to. Possible values are `application` or `network`. The default value is `application`. | `string` | `"application"` | no |
| <a name="input_load_balancing_algorithm_type"></a> [load\_balancing\_algorithm\_type](#input\_load\_balancing\_algorithm\_type) | Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. The value is `round_robin` or `least_outstanding_requests`. The default is `round_robin`. | `string` | `"round_robin"` | no |
| <a name="input_name"></a> [name](#input\_name) | Short, descriptive name of the environment. All resources will be named using this vaule as a prefix. | `string` | n/a | yes |
| <a name="input_nlb_health_check"></a> [nlb\_health\_check](#input\_nlb\_health\_check) | Map of health check options for NLBs. Options that have associated validations have defaults here. All other options in `local.nlb_health_check_defaults` can be overridden here.<br>  Default values are:<pre>nlb_health_check_defaults = {<br>    enabled                     = true<br>    healthy_unhealthy_threshold = 3<br>    interval                    = 30<br>    path                        = null<br>    port                        = "traffic-port"<br>    protocol                    = "TCP"<br>  }</pre>See [health\_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check) for documentation of the options. | `map(string)` | <pre>{<br>  "enabled": true,<br>  "port": "traffic-port"<br>}</pre> | no |
| <a name="input_nlb_stickiness"></a> [nlb\_stickiness](#input\_nlb\_stickiness) | Map of stickiness options for NLBs. In order to override, you will need to populate all appropriate options. See [stickiness](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#stickiness) for documentation of the options. | `map(string)` | <pre>{<br>  "enabled": true,<br>  "type": "source_ip"<br>}</pre> | no |
| <a name="input_port"></a> [port](#input\_port) | (May be required, Forces new resource) Port on which targets receive traffic, unless overridden when registering a specific target. Required when `target_type` is `instance` or `ip`. Does not apply when `target_type` is `lambda`. | `string` | `null` | no |
| <a name="input_preserve_client_ip"></a> [preserve\_client\_ip](#input\_preserve\_client\_ip) | (Optional) Whether client IP preservation is enabled. See [doc](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#client-ip-preservation) for more information. | `bool` | `true` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (May be required, Forces new resource) Protocol to use for routing traffic to the targets. Should be one of `HTTP`, `HTTPS`, `TCP`, `TCP_UDP`, `TLS`, or `UDP`. Required when `target_type` is `instance` or `ip`. Does not apply when `target_type` is `lambda`. | `string` | `null` | no |
| <a name="input_protocol_version"></a> [protocol\_version](#input\_protocol\_version) | (Optional, Forces new resource) Only applicable when protocol is `HTTP` or `HTTPS`. The protocol version. Specify `GRPC` to send requests to targets using gRPC. Specify `HTTP2` to send requests to targets using HTTP/2. The default is `HTTP1`, which sends requests to targets using HTTP/1.1 | `string` | `"HTTP1"` | no |
| <a name="input_proxy_protocol_v2"></a> [proxy\_protocol\_v2](#input\_proxy\_protocol\_v2) | Whether to enable support for proxy protocol v2 on Network Load Balancers. See [doc](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-target-groups.html#proxy-protocol) for more information. Default is `false`. | `bool` | `false` | no |
| <a name="input_slow_start"></a> [slow\_start](#input\_slow\_start) | Amount of time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds. | `string` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tag names and values for tags to apply to all taggable resources created by the module. Default value is a blank map to allow for using Default Tags in the provider. | `map(string)` | `{}` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | (May be required, Forces new resource) Type of target that you must specify when registering targets with this target group. The possible values are `instance` (targets are specified by instance ID) or `ip` (targets are specified by IP address) or `lambda` (targets are specified by lambda arn). The default is `instance`. Note that you can't specify targets for a target group using both instance IDs and IP addresses. If the target type is `ip`, specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group, the RFC 1918 range (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16), and the RFC 6598 range (100.64.0.0/10). You can't specify publicly routable IP addresses. | `string` | `"instance"` | no |
| <a name="input_tg_name_override"></a> [tg\_name\_override](#input\_tg\_name\_override) | Used if there is a need to specify a target group name outside of the standardized nomenclature. For example, if importing a target group that doesn't follow the standard naming formats. | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Identifier of the VPC in which to create the target group. Required when target\_type is `instance` or `ip`. Does not apply when target\_type is `lambda`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tg"></a> [tg](#output\_tg) | Collection of outputs for the Target Group |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
