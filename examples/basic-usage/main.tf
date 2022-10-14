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
  default = "example-lb"
}

## Create a VPC, since that is a requirement for the Load Balancer

module "vpc" {
  source  = "so1omon563/vpc/aws"
  version = "1.0.0"

  name = var.name
  tags = {
    example = "true"
  }
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
  tags = {
    example = "true"
  }
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

  tags = {
    example = "true"
  }
}

## Create the load balancers
## Creates with a default HTTPS listener / Target Group on public subnets
## Includes `name_type` value (can be whatever you want) to differentiate it from the other ALB
## Could have also used the `name_random` options to add a random hex value to the name.
module "alb-public" {
  source = "../../"

  name = var.name
  tags = {
    example = "true"
  }
  name_type          = "public"
  vpc_id             = module.vpc.vpc_id
  subnets            = data.aws_subnets.public_subnets.ids
  security_groups    = [module.web-sg.security-group.id]
  certificate_arn    = aws_acm_certificate.dummy.arn
  load_balancer_type = "application"
}
output "alb-public" { value = module.alb-public }

## Creates with a default HTTP listener / Target Group on private subnets
module "alb" {
  source = "../../"

  name = var.name
  tags = {
    example = "true"
  }
  vpc_id             = module.vpc.vpc_id
  subnets            = data.aws_subnets.private_subnets.ids
  security_groups    = [module.web-sg.security-group.id]
  load_balancer_type = "application"
  internal           = true
  alb = {
    idle_timeout = 20
  }
}
output "alb" { value = module.alb }

## Creates with a default TCP listener / Target Group on public subnets
module "nlb" {
  source = "../../"

  name = var.name
  tags = {
    example = "true"
  }
  vpc_id             = module.vpc.vpc_id
  subnets            = data.aws_subnets.public_subnets.ids
  load_balancer_type = "network"
  nlb = {
    enable_cross_zone_load_balancing = true
  }
}
output "nlb" { value = module.nlb }
