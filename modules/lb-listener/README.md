# Load Balancer Listener

This submodule creates a Listener that can be attached to an Application or Network [Load Balancer](../..).

This module only supports a single default action at this time.

This module does not support `authenticate-cognito` or `authenticate-oidc` actions at this time.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Auto-generated technical documentation is created using [`terraform-docs`](https://terraform-docs.io/)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alpn_policy"></a> [alpn\_policy](#input\_alpn\_policy) | (Optional) Name of the Application-Layer Protocol Negotiation (ALPN) policy. Can be set if `protocol` is `TLS`. Valid values are `HTTP1Only`, `HTTP2Only`, `HTTP2Optional`, `HTTP2Preferred`, and `None`. | `string` | `null` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | (Optional) ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS | `string` | `null` | no |
| <a name="input_fixed_response_content_type"></a> [fixed\_response\_content\_type](#input\_fixed\_response\_content\_type) | (Required for listeners of `type` : `fixed_response`) Content type. Valid values are `text/plain`, `text/css`, `text/html`, `application/javascript` and `application/json`. | `string` | `null` | no |
| <a name="input_fixed_response_message_body"></a> [fixed\_response\_message\_body](#input\_fixed\_response\_message\_body) | (Optional for listeners of `type` : `fixed_response`) Message body. | `string` | `null` | no |
| <a name="input_fixed_response_status_code"></a> [fixed\_response\_status\_code](#input\_fixed\_response\_status\_code) | (Optional for listeners of `type` : `fixed_response`) HTTP response code. Valid values are `2XX`, `4XX`, or `5XX`. | `string` | `null` | no |
| <a name="input_forward_stickiness_block"></a> [forward\_stickiness\_block](#input\_forward\_stickiness\_block) | Map of stickiness options for the listener rule. Duration is a value in seconds between 1-604800 (7 days). See [stickiness](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#stickiness) for documentation of the options. | `map(string)` | <pre>{<br>  "duration": 86400,<br>  "enabled": true<br>}</pre> | no |
| <a name="input_forward_target_group_arn"></a> [forward\_target\_group\_arn](#input\_forward\_target\_group\_arn) | (Optional) ARN of the Target Group to which to route traffic. Specify only if `type` is `forward` and you want to route to a single target group. To route to one or more target groups, use a `forward` block instead. | `string` | `null` | no |
| <a name="input_forward_target_group_block"></a> [forward\_target\_group\_block](#input\_forward\_target\_group\_block) | (Optional) Map of up to 5 ARNs of Target Groups to which to route traffic, and their associated weight.<br>  Weight is a range from 0-999.<br>  Specify `arn` as the `key`, and `weight` as the `value`.<br>  Specify only if `type` is `forward` and you want to route to multiple target groups. To route to a single target groups, use `var.forward_target_group_arn` instead.<br><br>  Example:<pre>{<br>    arn1 : 8<br>    arn2 : 2<br>  }</pre> | `map(string)` | `null` | no |
| <a name="input_load_balancer_arn"></a> [load\_balancer\_arn](#input\_load\_balancer\_arn) | (Required, Forces New Resource) ARN of the load balancer. | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | (Optional) Port on which the load balancer is listening. Not valid for Gateway Load Balancers. | `string` | `null` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Optional) Protocol for connections from clients to the load balancer. For Application Load Balancers, valid values are `HTTP` and `HTTPS`, with a default of `HTTP`. For Network Load Balancers, valid values are `TCP`, `TLS`, `UDP`, and `TCP_UDP`. Not valid to use `UDP` or `TCP_UDP` if dual-stack mode is enabled. Not valid for Gateway Load Balancers. | `string` | `null` | no |
| <a name="input_redirect_host"></a> [redirect\_host](#input\_redirect\_host) | (Optional for listeners of `type` : `redirect`) Hostname. This component is not percent-encoded. The hostname can contain `#{host}`. Defaults to `#{host}` if not specified. | `string` | `null` | no |
| <a name="input_redirect_path"></a> [redirect\_path](#input\_redirect\_path) | (Optional for listeners of `type` : `redirect`) Absolute path, starting with the leading '/'. This component is not percent-encoded. The path can contain `#{host}`, `#{path}`, and `#{port}`. Defaults to `/#{path} if not specified`. | `string` | `null` | no |
| <a name="input_redirect_port"></a> [redirect\_port](#input\_redirect\_port) | (Optional for listeners of `type` : `redirect`) Port. Specify a value from `1` to `65535` or `#{port}`. Defaults to `#{port}` if not specified. | `string` | `null` | no |
| <a name="input_redirect_protocol"></a> [redirect\_protocol](#input\_redirect\_protocol) | (Optional for listeners of `type` : `redirect`) Protocol. Valid values are `HTTP`, `HTTPS`, or `#{protocol}`. Defaults to `#{protocol}` if not specified. | `string` | `null` | no |
| <a name="input_redirect_query"></a> [redirect\_query](#input\_redirect\_query) | (Optional for listeners of `type` : `redirect`) Query parameters, URL-encoded when necessary, but not percent-encoded. Do not include the leading '?'. Defaults to `#{query}` if not specified. | `string` | `null` | no |
| <a name="input_redirect_status_code"></a> [redirect\_status\_code](#input\_redirect\_status\_code) | (Required for listeners of `type` : `redirect`) HTTP redirect code. The redirect is either permanent (`HTTP_301`) or temporary (`HTTP_302`). | `string` | `null` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | (Optional) Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tag names and values for tags to apply to all taggable resources created by the module. Default value is a blank map to allow for using Default Tags in the provider. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of routing action. Valid values are `forward`, `redirect`, `fixed-response`. | `string` | `"forward"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_listener"></a> [listener](#output\_listener) | Collection of outputs for the listener. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
