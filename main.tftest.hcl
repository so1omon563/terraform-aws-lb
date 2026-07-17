mock_provider "aws" {}

run "default_application_lb" {
  command = plan

  variables {
    name            = "example"
    subnets         = ["subnet-1234567890abcdef0", "subnet-abcdef01234567890"]
    security_groups = ["sg-1234567890abcdef0"]
    vpc_id          = "vpc-1234567890abcdef0"
    tags = {
      environment = "test"
    }
  }

  assert {
    condition     = aws_lb.alb["application"].name == "example-alb"
    error_message = "Expected the default ALB name to use var.name."
  }

  assert {
    condition     = aws_lb.alb["application"].load_balancer_type == "application"
    error_message = "Expected an application load balancer by default."
  }

  assert {
    condition     = length(module.alb-listener) == 1
    error_message = "Expected a default ALB listener."
  }

  assert {
    condition     = length(module.alb-tg) == 1
    error_message = "Expected a default ALB target group."
  }
}

run "network_lb" {
  command = plan

  variables {
    name               = "example"
    load_balancer_type = "network"
    subnets            = ["subnet-1234567890abcdef0", "subnet-abcdef01234567890"]
    vpc_id             = "vpc-1234567890abcdef0"
  }

  assert {
    condition     = aws_lb.nlb["network"].name == "example-nlb"
    error_message = "Expected the default NLB name to use var.name."
  }

  assert {
    condition     = aws_lb.nlb["network"].load_balancer_type == "network"
    error_message = "Expected a network load balancer."
  }

  assert {
    condition     = length(module.nlb-listener) == 1
    error_message = "Expected a default NLB listener."
  }
}

run "lambda_target_group" {
  command = plan

  variables {
    name            = "example"
    subnets         = ["subnet-1234567890abcdef0", "subnet-abcdef01234567890"]
    security_groups = ["sg-1234567890abcdef0"]
    target_type     = "lambda"
    vpc_id          = "vpc-1234567890abcdef0"
  }

  assert {
    condition     = output.default_tg["application"].tg["application"].load_balancing_algorithm_type == null
    error_message = "Expected Lambda target groups to omit the load balancing algorithm."
  }
}

run "listener_disabled" {
  command = plan

  variables {
    name             = "example"
    default_listener = false
    subnets          = ["subnet-1234567890abcdef0", "subnet-abcdef01234567890"]
    vpc_id           = "vpc-1234567890abcdef0"
  }

  assert {
    condition     = length(module.alb-listener) == 0
    error_message = "Expected no default ALB listener when default_listener is false."
  }

  assert {
    condition     = length(module.alb-tg) == 0
    error_message = "Expected no default ALB target group when default_listener is false."
  }
}
