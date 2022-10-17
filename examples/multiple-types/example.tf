provider "aws" {
  default_tags {
    tags = {
      environment = "dev"
      terraform   = "true"
    }
  }
}

## Variables

variable "name" {
  type    = string
  default = "example-lb-multi"
}

variable "tags" {
  type = map(string)
  default = {
    example = "true"
  }
}

## Create a VPC, since that is a requirement for the Load Balancer

module "vpc" {
  source  = "so1omon563/vpc/aws"
  version = "1.0.0"

  name = var.name
  tags = var.tags
}
output "vpc" { value = module.vpc }

## Create a Security Group, since that is a requirement for the Load Balancer

module "web-sg" {
  source  = "so1omon563/security-group/aws"
  version = "1.0.0"

  name        = var.name
  vpc_id      = module.vpc.vpc_id
  type        = "web"
  description = "HTTP security group"
  tags        = var.tags
}

# Get information about subnets in VPC
data "aws_subnets" "public_subnets" {
  depends_on = [module.vpc]
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  tags = {
    network = "public"
  }
}

data "aws_subnets" "private_subnets" {
  depends_on = [module.vpc]
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  tags = {
    network = "private"
  }
}

## Create a dummy self-signed certificate for the load balancers
resource "tls_private_key" "dummy" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "dummy" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.dummy.private_key_pem

  subject {
    common_name  = "dummy.com"
    organization = "Fake Dummy Inc."
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "dummy" {
  private_key      = tls_private_key.dummy.private_key_pem
  certificate_body = tls_self_signed_cert.dummy.cert_pem

  tags = var.tags
}

# Creating load balancers with `default_listener` set to `false` so we can create customized target groups and listeners.
# Creating 2 ALBs with the same details to show the name_random option
module "alb-app-1" {
  source  = "so1omon563/lb/aws"
  version = "1.0.0"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  subnets            = data.aws_subnets.private_subnets.ids
  security_groups    = [module.web-sg.security-group.id]
  load_balancer_type = "application"
  default_listener   = false
  internal           = true
  alb = {
    idle_timeout = 20
  }
  name_type   = "app"
  name_random = true
}
output "alb-app-1" { value = module.alb-app-1 }

module "alb-app-2" {
  source  = "so1omon563/lb/aws"
  version = "1.0.0"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  subnets            = data.aws_subnets.private_subnets.ids
  security_groups    = [module.web-sg.security-group.id]
  load_balancer_type = "application"
  default_listener   = false
  internal           = true
  alb = {
    idle_timeout = 20
  }
  name_type   = "app"
  name_random = true
}
output "alb-app-2" { value = module.alb-app-2 }

# Creating an NLB

module "nlb" {
  source  = "so1omon563/lb/aws"
  version = "1.0.0"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  subnets            = data.aws_subnets.public_subnets.ids
  load_balancer_type = "network"
  default_listener   = false
  nlb = {
    enable_cross_zone_load_balancing = true
  }
}
output "nlb" { value = module.nlb }

# Create Target Groups
module "alb-tg-http" {
  source  = "so1omon563/lb/aws//modules/lb-target-group"
  version = "1.0.0"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  load_balancer_type = "application"
  port               = 80
  protocol           = "HTTP"
}
output "alb-tg-http" { value = module.alb-tg-http }

module "alb-tg-http-8080" {
  source  = "so1omon563/lb/aws//modules/lb-target-group"
  version = "1.0.0"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  load_balancer_type = "application"
  port               = 8080
  protocol           = "HTTP"
}
output "alb-tg-http-8080" { value = module.alb-tg-http-8080 }

module "nlb-tg-tcp" {
  source  = "so1omon563/lb/aws//modules/lb-target-group"
  version = "1.0.0"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  load_balancer_type = "network"
  port               = 80
  protocol           = "TCP"
}
output "nlb-tg-tcp" { value = module.nlb-tg-tcp }

# Create listeners

module "alb-listener-basic-http" {
  source  = "so1omon563/lb/aws//modules/lb-listener"
  version = "1.0.0"

  tags                     = var.tags
  load_balancer_arn        = module.alb-app-1.lb.application.arn
  port                     = 80
  protocol                 = "HTTP"
  forward_target_group_arn = module.alb-tg-http.tg.application.arn
}
output "alb-listener-basic-http" { value = module.alb-listener-basic-http }

module "alb-listener-basic-https" {
  source  = "so1omon563/lb/aws//modules/lb-listener"
  version = "1.0.0"

  tags                     = var.tags
  load_balancer_arn        = module.alb-app-1.lb.application.arn
  port                     = 443
  protocol                 = "HTTPS"
  certificate_arn          = aws_acm_certificate.dummy.arn
  forward_target_group_arn = module.alb-tg-http.tg.application.arn
}

output "alb-listener-basic-https" { value = module.alb-listener-basic-https }

module "alb-listener-fixed-response" {
  source  = "so1omon563/lb/aws//modules/lb-listener"
  version = "1.0.0"

  tags                        = var.tags
  load_balancer_arn           = module.alb-app-1.lb.application.arn
  port                        = 8080
  protocol                    = "HTTP"
  type                        = "fixed-response"
  fixed_response_content_type = "text/plain"
  fixed_response_status_code  = "200"
}
output "alb-listener-fixed-response" { value = module.alb-listener-fixed-response }

module "alb-listener-redirect" {
  source  = "so1omon563/lb/aws//modules/lb-listener"
  version = "1.0.0"

  tags                 = var.tags
  load_balancer_arn    = module.alb-app-1.lb.application.arn
  port                 = 8081
  protocol             = "HTTP"
  type                 = "redirect"
  redirect_status_code = "HTTP_301"
  redirect_port        = 80
}
output "alb-listener-redirect" { value = module.alb-listener-redirect }

module "alb-listener-forward-block" {
  source  = "so1omon563/lb/aws//modules/lb-listener"
  version = "1.0.0"

  tags              = var.tags
  load_balancer_arn = module.alb-app-1.lb.application.arn
  port              = 8082
  protocol          = "HTTP"
  type              = "forward"
  forward_target_group_block = {
    (module.alb-tg-http.tg.application.arn) : 8
    (module.alb-tg-http-8080.tg.application.arn) : 2
  }
}
output "alb-listener-forward-block" { value = module.alb-listener-forward-block }

module "nlb-listener-tcp" {
  source  = "so1omon563/lb/aws//modules/lb-listener"
  version = "1.0.0"

  tags                     = var.tags
  load_balancer_arn        = module.nlb.lb.network.arn
  port                     = 80
  protocol                 = "TCP"
  forward_target_group_arn = module.nlb-tg-tcp.tg.network.arn
}
output "nlb-listener-tcp" { value = module.nlb-listener-tcp }

module "nlb-listener-tls" {
  source  = "so1omon563/lb/aws//modules/lb-listener"
  version = "1.0.0"

  tags                     = var.tags
  load_balancer_arn        = module.nlb.lb.network.arn
  port                     = 443
  protocol                 = "TLS"
  certificate_arn          = aws_acm_certificate.dummy.arn
  forward_target_group_arn = module.nlb-tg-tcp.tg.network.arn
}
output "nlb-listener-tls" { value = module.nlb-listener-tls }
