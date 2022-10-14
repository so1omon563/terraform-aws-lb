# Multiple Types

Examples can be found in the `*.tf` source files.

Example demonstrates creation of multiple load balancer / listener / target group types.

Example shows using Default Tags in the provider as well as passing additional tags into the resource.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.34.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb-app-1"></a> [alb-app-1](#module\_alb-app-1) | so1omon563/lb/aws | 1.0.0 |
| <a name="module_alb-app-2"></a> [alb-app-2](#module\_alb-app-2) | so1omon563/lb/aws | 1.0.0 |
| <a name="module_alb-listener-basic-http"></a> [alb-listener-basic-http](#module\_alb-listener-basic-http) | so1omon563/lb/aws//modules/lb-listener | 1.0.0 |
| <a name="module_alb-listener-basic-https"></a> [alb-listener-basic-https](#module\_alb-listener-basic-https) | so1omon563/lb/aws//modules/lb-listener | 1.0.0 |
| <a name="module_alb-listener-fixed-response"></a> [alb-listener-fixed-response](#module\_alb-listener-fixed-response) | so1omon563/lb/aws//modules/lb-listener | 1.0.0 |
| <a name="module_alb-listener-forward-block"></a> [alb-listener-forward-block](#module\_alb-listener-forward-block) | so1omon563/lb/aws//modules/lb-listener | 1.0.0 |
| <a name="module_alb-listener-redirect"></a> [alb-listener-redirect](#module\_alb-listener-redirect) | so1omon563/lb/aws//modules/lb-listener | 1.0.0 |
| <a name="module_alb-tg-http"></a> [alb-tg-http](#module\_alb-tg-http) | so1omon563/lb/aws//modules/lb-target-group | 1.0.0 |
| <a name="module_alb-tg-http-8080"></a> [alb-tg-http-8080](#module\_alb-tg-http-8080) | so1omon563/lb/aws//modules/lb-target-group | 1.0.0 |
| <a name="module_nlb"></a> [nlb](#module\_nlb) | so1omon563/lb/aws | 1.0.0 |
| <a name="module_nlb-listener-tcp"></a> [nlb-listener-tcp](#module\_nlb-listener-tcp) | so1omon563/lb/aws//modules/lb-listener | 1.0.0 |
| <a name="module_nlb-listener-tls"></a> [nlb-listener-tls](#module\_nlb-listener-tls) | so1omon563/lb/aws//modules/lb-listener | 1.0.0 |
| <a name="module_nlb-tg-tcp"></a> [nlb-tg-tcp](#module\_nlb-tg-tcp) | so1omon563/lb/aws//modules/lb-target-group | 1.0.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | so1omon563/vpc/aws | 1.0.0 |
| <a name="module_web-sg"></a> [web-sg](#module\_web-sg) | so1omon563/security-group/aws | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.dummy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [tls_private_key.dummy](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.dummy](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_subnets.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"example-lb-multi"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "example": "true"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb-app-1"></a> [alb-app-1](#output\_alb-app-1) | n/a |
| <a name="output_alb-app-2"></a> [alb-app-2](#output\_alb-app-2) | n/a |
| <a name="output_alb-listener-basic-http"></a> [alb-listener-basic-http](#output\_alb-listener-basic-http) | n/a |
| <a name="output_alb-listener-basic-https"></a> [alb-listener-basic-https](#output\_alb-listener-basic-https) | n/a |
| <a name="output_alb-listener-fixed-response"></a> [alb-listener-fixed-response](#output\_alb-listener-fixed-response) | n/a |
| <a name="output_alb-listener-forward-block"></a> [alb-listener-forward-block](#output\_alb-listener-forward-block) | n/a |
| <a name="output_alb-listener-redirect"></a> [alb-listener-redirect](#output\_alb-listener-redirect) | n/a |
| <a name="output_alb-tg-http"></a> [alb-tg-http](#output\_alb-tg-http) | n/a |
| <a name="output_alb-tg-http-8080"></a> [alb-tg-http-8080](#output\_alb-tg-http-8080) | n/a |
| <a name="output_nlb"></a> [nlb](#output\_nlb) | n/a |
| <a name="output_nlb-listener-tcp"></a> [nlb-listener-tcp](#output\_nlb-listener-tcp) | n/a |
| <a name="output_nlb-listener-tls"></a> [nlb-listener-tls](#output\_nlb-listener-tls) | n/a |
| <a name="output_nlb-tg-tcp"></a> [nlb-tg-tcp](#output\_nlb-tg-tcp) | n/a |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
