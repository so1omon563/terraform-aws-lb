# Output for the example EBS volume
output "listener" {
  value       = { for k, v in aws_lb_listener.listener : k => v }
  description = "Collection of outputs for the listener."
}
