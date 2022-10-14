variable "name" {}
variable "tags" {}

# Create VPC
module "vpc" {
  source  = "so1omon563/vpc/aws"
  version = "1.0.0"

  name = var.name
  tags = var.tags
}

output "vpc" { value = module.vpc }

# Create Security Group
module "sg" {
  depends_on = [module.vpc]

  source  = "so1omon563/security-group/aws"
  version = "1.0.0"

  name   = var.name
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}
output "sg" { value = module.sg }

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

# Load Balancers
module "alb" {
  depends_on = [
    module.sg
  ]
  source           = "../../../"
  name             = var.name
  tags             = var.tags
  vpc_id           = module.vpc.vpc_id
  subnets          = data.aws_subnets.private_subnets.ids
  security_groups  = [module.sg.security-group.id]
  default_listener = false
}
output "alb" { value = module.alb }

module "alb-override" {
  depends_on = [
    module.sg
  ]
  source           = "../../../"
  name             = var.name
  tags             = var.tags
  vpc_id           = module.vpc.vpc_id
  subnets          = data.aws_subnets.private_subnets.ids
  security_groups  = [module.sg.security-group.id]
  lb_name_override = "kitchen-override"
  default_listener = false

}
output "alb-override" { value = module.alb-override }

module "alb-default-80" {
  depends_on = [
    module.sg
  ]
  source          = "../../../"
  name            = var.name
  tags            = var.tags
  vpc_id          = module.vpc.vpc_id
  subnets         = data.aws_subnets.private_subnets.ids
  security_groups = [module.sg.security-group.id]
  lb_name_type    = "80"
}
output "alb-default-80" { value = module.alb-default-80 }

module "alb-default-443" {
  depends_on = [
    module.sg
  ]
  source          = "../../../"
  name            = var.name
  tags            = var.tags
  vpc_id          = module.vpc.vpc_id
  subnets         = data.aws_subnets.private_subnets.ids
  security_groups = [module.sg.security-group.id]
  lb_name_type    = "443"
  certificate_arn = aws_acm_certificate.dummy.arn
  target_type     = "ip"
}
output "alb-default-443" { value = module.alb-default-443 }

module "nlb" {
  source = "../../../"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  subnets            = data.aws_subnets.public_subnets.ids
  load_balancer_type = "network"
  default_listener   = false
}
output "nlb" { value = module.nlb }

module "nlb-default-80" {
  source = "../../../"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  subnets            = data.aws_subnets.public_subnets.ids
  load_balancer_type = "network"
  lb_name_type       = "80"
}
output "nlb-default-80" { value = module.nlb-default-80 }

module "nlb-default-443" {
  source = "../../../"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  subnets            = data.aws_subnets.public_subnets.ids
  load_balancer_type = "network"
  lb_name_type       = "443"
  certificate_arn    = aws_acm_certificate.dummy.arn
}
output "nlb-default-443" { value = module.nlb-default-443 }

# Target Groups
module "alb-tg" {
  source = "../../../modules//lb-target-group/"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  load_balancer_type = "application"
  port               = 80
  protocol           = "HTTP"
}
output "alb-tg" { value = module.alb-tg }

module "nlb-tg" {
  source = "../../../modules//lb-target-group/"

  name               = var.name
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  load_balancer_type = "network"
  port               = 80
  protocol           = "TCP"
}
output "nlb-tg" { value = module.nlb-tg }

module "alb-tg-override" {
  source = "../../../modules//lb-target-group/"

  name               = var.name
  tg_name_override   = "alb-tg-testing"
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  load_balancer_type = "application"
  port               = 80
  protocol           = "HTTP"
}
output "alb-tg-override" { value = module.alb-tg-override }

module "nlb-tg-override" {
  source = "../../../modules//lb-target-group/"

  name               = var.name
  tg_name_override   = "nlb-tg-testing"
  tags               = var.tags
  vpc_id             = module.vpc.vpc_id
  load_balancer_type = "network"
  port               = 80
  protocol           = "TCP"
}
output "nlb-tg-override" { value = module.nlb-tg-override }

# Listeners
module "alb-listener" {
  source = "../../../modules//lb-listener/"

  tags                     = var.tags
  load_balancer_arn        = module.alb.lb.application.arn
  port                     = 80
  protocol                 = "HTTP"
  forward_target_group_arn = module.alb-tg.tg.application.arn
}
output "alb-listener" { value = module.alb-listener }

module "nlb-listener" {
  source = "../../../modules//lb-listener/"

  tags                     = var.tags
  load_balancer_arn        = module.nlb.lb.network.arn
  port                     = 80
  protocol                 = "TCP"
  forward_target_group_arn = module.nlb-tg.tg.network.arn
}
output "nlb-listener" { value = module.nlb-listener }
