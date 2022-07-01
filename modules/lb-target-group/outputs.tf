output "tg" {
  value = merge(
    {
      for key, value in aws_lb_target_group.alb-tg : key => value
    },
    {
      for key, value in aws_lb_target_group.nlb-tg : key => value
    }
  )
  description = "Collection of outputs for the Target Group"
}
