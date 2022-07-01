# Load Balancer

Creates a Load Balancer (Application or Network).

**Note that this module does not currently support Gateway Load Balancers. It also does not support Classic ELBs.**

**This set of modules does not currently support additional listener rules. At this time, custom listener rules apart from the default action should be added separately to the resources created by these modules.**

By default, this module will also create a default listener / target group. If a `certificate_arn` is provided, it will create it on port 443 and HTTPS or TLS, depending on the `load_balancer_type`. If no `certificate_arn` is provided, it creates it on port 80 and HTTP / TCP.

These default listeners and target groups are created by the [lb-target-group](modules/lb-target-group) and [lb-listener](modules/lb-listener) submodules. The `lb-listener` submodule only supports a single default action on listeners, and it does not support `authenticate-cognito` or `authenticate-oidc` actions at this time.

If desired, the `default_listener` variable can be set to `false`, and you can directly call the submodules to create custom target groups and listeners.

See the [multiple-types](examples/multiple-types) example for examples of how this can be done.
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
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb-listener"></a> [alb-listener](#module\_alb-listener) | ./modules//lb-listener/ | n/a |
| <a name="module_alb-tg"></a> [alb-tg](#module\_alb-tg) | ./modules//lb-target-group/ | n/a |
| <a name="module_nlb-listener"></a> [nlb-listener](#module\_nlb-listener) | ./modules//lb-listener/ | n/a |
| <a name="module_nlb-tg"></a> [nlb-tg](#module\_nlb-tg) | ./modules//lb-target-group/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_bucket"></a> [access\_logs\_bucket](#input\_access\_logs\_bucket) | The name of the S3 bucket to log LB access to. | `string` | `null` | no |
| <a name="input_access_logs_prefix"></a> [access\_logs\_prefix](#input\_access\_logs\_prefix) | The S3 bucket prefix for access logs. If not configured, logs are stored in the root of the bucket. | `string` | `null` | no |
| <a name="input_alb"></a> [alb](#input\_alb) | A map of variables for an application load balancer. Options in `local.alb_defaults` can be overridden here.<br>  Default values are:<pre>alb_defaults = {<br>    drop_invalid_header_fields = false<br>    idle_timeout               = 60<br>    enable_http2               = true<br>  }</pre>See [aws\_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) for more information on the options | `map(string)` | `{}` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | If `default_listener` is set to `true`, this is the ARN of the SSL server certificate to use for the default listener if `HTTPS` or `TLS` is desired. | `string` | `null` | no |
| <a name="input_customer_owned_ipv4_pool"></a> [customer\_owned\_ipv4\_pool](#input\_customer\_owned\_ipv4\_pool) | The ID of the customer owned ipv4 pool to use for this load balancer. | `string` | `null` | no |
| <a name="input_default_listener"></a> [default\_listener](#input\_default\_listener) | Creates a default forwarding listener and target group, based on the load balancer type. If a `certificate_arn` value is provided, the listener will be `HTTPS` or `TLS`, otherwise it will be `HTTP` or `TCP`. | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | If true, the LB will be internal. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`. Internal LBs can only use `ipv4`. You can only use `dualstack` if the selected subnets are IPv6 enabled. | `string` | `"ipv4"` | no |
| <a name="input_lb_name_override"></a> [lb\_name\_override](#input\_lb\_name\_override) | Used if there is a need to specify a LB name outside of the standardized nomenclature. For example, if importing a load ballancer that doesn't follow the standard naming formats. | `string` | `null` | no |
| <a name="input_lb_name_random"></a> [lb\_name\_random](#input\_lb\_name\_random) | If there are multiple of the same type of LB in an environment, setting this as `true` will add a random hex to the `name` of the LB. | `bool` | `false` | no |
| <a name="input_lb_name_type"></a> [lb\_name\_type](#input\_lb\_name\_type) | If there are multiple of the same type of LB in an environment, adding a type descriptor here (web, app, internal, etc) will add it to the `name` of the LB. | `string` | `null` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of load balancer to create. Possible values are `application` or `network`. The default value is `application`. | `string` | `"application"` | no |
| <a name="input_name"></a> [name](#input\_name) | Short, descriptive name of the environment. All resources will be named using this value as a prefix. | `string` | n/a | yes |
| <a name="input_nlb"></a> [nlb](#input\_nlb) | A map of variables for a network load balancer. Options in `local.nlb_defaults` can be overridden here.<br>  Default values are:<pre>nlb_defaults = {<br>    enable_cross_zone_load_balancing = false<br>  }</pre>See [aws\_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) for more information on the options | `map(string)` | `{}` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of Security Group IDs to attach to the LB. Only valid for Load Balancers of type `application`. | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs to attach to the LB. Please note that updating subnets for Load Balancers of type `network` will force a recreation of the resource. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tag names and values for tags to apply to all taggable resources created by the module. Default value is a blank map to allow for using Default Tags in the provider. | `map(string)` | `{}` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | If `default_listener` is set to `true`, this is the type of target that you must specify when registering targets with the default target group. The possible values are `instance` (targets are specified by instance ID) or `ip` (targets are specified by IP address) or `lambda` (targets are specified by lambda arn). The default is `instance`. Note that you can't specify targets for a target group using both instance IDs and IP addresses. If the target type is `ip`, specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group, the RFC 1918 range (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16), and the RFC 6598 range (100.64.0.0/10). You can't specify publicly routable IP addresses. | `string` | `"instance"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC these resources should be added to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_listener"></a> [default\_listener](#output\_default\_listener) | Collection of outputs for the Default Listener - if one is created. |
| <a name="output_default_tg"></a> [default\_tg](#output\_default\_tg) | Collection of outputs for the Default Target Group - if one is created. |
| <a name="output_lb"></a> [lb](#output\_lb) | Collection of outputs for the Load Balancer |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
