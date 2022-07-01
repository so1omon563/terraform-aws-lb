output "lb" {
  value = merge(
    {
      for key, value in aws_lb.alb : key => value
    },
    {
      for key, value in aws_lb.nlb : key => value
    }
  )
  description = "Collection of outputs for the Load Balancer"
}

output "default_listener" {
  value = merge(
    {
      for key, value in module.alb-listener : key => value
    },
    {
      for key, value in module.nlb-listener : key => value
    }
  )
  description = "Collection of outputs for the Default Listener - if one is created."
}

output "default_tg" {
  value = merge(
    {
      for key, value in module.alb-tg : key => value
    },
    {
      for key, value in module.nlb-tg : key => value
    }
  )
  description = "Collection of outputs for the Default Target Group - if one is created."
}
