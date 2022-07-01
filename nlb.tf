resource "aws_lb" "nlb" {
  #checkov:skip=CKV_AWS_131: "Ensure that ALB drops HTTP headers" - Since this is a re-usable module, this needs to be able to be overridden.
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled" - Since this is a re-usable module, this needs to be able to be overridden.
  #checkov:skip=CKV_AWS_152: "Ensure that Load Balancer (Network/Gateway) has cross-zone load balancing enabled" - Since this is a re-usable module, this needs to be able to be overridden.

  for_each = local.nlb_type
  name     = local.nlb_name
  #tfsec:ignore:AWS005 - This needs to be able to be publicly exposed by design.
  internal           = var.internal
  load_balancer_type = each.key
  security_groups    = var.security_groups
  subnets            = var.subnets


  enable_deletion_protection = var.enable_deletion_protection
  customer_owned_ipv4_pool   = var.customer_owned_ipv4_pool
  ip_address_type            = var.ip_address_type

  enable_cross_zone_load_balancing = local.nlb.enable_cross_zone_load_balancing

  dynamic "access_logs" {
    for_each = var.access_logs_bucket[*]

    content {
      bucket  = access_logs.value
      prefix  = var.access_logs_prefix
      enabled = true
    }
  }

  tags = merge({ "Name" = local.nlb_name }, local.tags)
}
