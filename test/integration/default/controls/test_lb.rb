# frozen_string_literal: true

include_controls 'inspec-aws'

require './test/library/common'

tfstate = StateFileReader.new

alb_id = tfstate.read['outputs']['alb']['value']['lb']['application']['arn'].to_s
alb_tg_id = tfstate.read['outputs']['alb-tg']['value']['tg']['application']['arn'].to_s
alb_listener_id = tfstate.read['outputs']['alb-listener']['value']['listener']['arn'].to_s
alb_override_id = tfstate.read['outputs']['alb-override']['value']['lb']['application']['arn'].to_s
alb_80_id = tfstate.read['outputs']['alb-default-80']['value']['lb']['application']['arn'].to_s
alb_80_tg_id = tfstate.read['outputs']['alb-default-80']['value']['default_tg']['application']['tg']['application']['arn'].to_s
alb_80_listener_id = tfstate.read['outputs']['alb-default-80']['value']['default_listener']['application']['listener']['arn'].to_s
alb_443_id = tfstate.read['outputs']['alb-default-443']['value']['lb']['application']['arn'].to_s
alb_443_tg_id = tfstate.read['outputs']['alb-default-443']['value']['default_tg']['application']['tg']['application']['arn'].to_s
alb_443_listener_id = tfstate.read['outputs']['alb-default-443']['value']['default_listener']['application']['listener']['arn'].to_s
alb_443_listener_certificate_arn = tfstate.read['outputs']['alb-default-443']['value']['default_listener']['application']['listener']['certificate_arn'].to_s
nlb_id = tfstate.read['outputs']['nlb']['value']['lb']['network']['arn'].to_s
nlb_tg_id = tfstate.read['outputs']['nlb-tg']['value']['tg']['network']['arn'].to_s
nlb_listener_id = tfstate.read['outputs']['nlb-listener']['value']['listener']['arn'].to_s
nlb_80_id = tfstate.read['outputs']['nlb-default-80']['value']['lb']['network']['arn'].to_s
nlb_80_tg_id = tfstate.read['outputs']['nlb-default-80']['value']['default_tg']['network']['tg']['network']['arn'].to_s
nlb_80_listener_id = tfstate.read['outputs']['nlb-default-80']['value']['default_listener']['network']['listener']['arn'].to_s
nlb_443_id = tfstate.read['outputs']['nlb-default-443']['value']['lb']['network']['arn'].to_s
nlb_443_tg_id = tfstate.read['outputs']['nlb-default-443']['value']['default_tg']['network']['tg']['network']['arn'].to_s
nlb_443_listener_id = tfstate.read['outputs']['nlb-default-443']['value']['default_listener']['network']['listener']['arn'].to_s
nlb_443_listener_certificate_arn = tfstate.read['outputs']['nlb-default-443']['value']['default_listener']['network']['listener']['certificate_arn'].to_s

sg_id = tfstate.read['outputs']['sg']['value']['security-group']['id'].to_s
vpc_id = tfstate.read['outputs']['sg']['value']['security-group']['vpc_id'].to_s

control 'default' do
  describe aws_alb(alb_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_alb.md
    it { should exist }
    its('load_balancer_name') { should cmp 'kitchen-alb' }
    its('state') { should include 'active' }
    its('scheme') { should cmp 'internet-facing' }
    its('security_groups') { should include sg_id }
    its('security_groups.count') { should be 1 }
    its('vpc_id') { should cmp vpc_id }
    its('type') { should eq 'application' }
    its('subnets.count') { should be >= 2 }
    its('zone_names.count') { should be >= 2 }
  end

  describe aws_elasticloadbalancingv2_target_group(alb_tg_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_target_group.md
    it { should exist }
    its('target_group_name') { should cmp 'kitchen-80-http-alb' }
    its('protocol') { should cmp 'HTTP' }
    its('port') { should cmp '80' }
    its('vpc_id') { should cmp vpc_id }
    its('health_check_enabled') { should eq true }
    its('health_check_interval_seconds') { should eq 30 }
    its('health_check_timeout_seconds') { should eq 5 }
    its('health_check_path') { should eq '/' }
    its('health_check_port') { should eq 'traffic-port' }
    its('health_check_protocol') { should eq 'HTTP' }
    its('healthy_threshold_count') { should eq 3 }
    its('unhealthy_threshold_count') { should eq 3 }
    its('target_type') { should eq 'instance' }
    its('matcher.http_code') { should eq '200' }
    its('load_balancer_arns') { should include alb_id }
  end

  describe aws_elasticloadbalancingv2_listener(alb_listener_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_listener.md
    it { should exist }
    its('port') { should eq 80 }
    its('protocol') { should eq 'HTTP' }
    its('default_actions.first.type') { should eq 'forward' }
    its('default_actions.first.target_group_arn') { should eq alb_tg_id }
    its('default_actions.first.forward_config.target_groups.count') { should eq 1 }
    its('default_actions.first.forward_config.target_groups.first.target_group_arn') { should include alb_tg_id }
  end

  describe aws_alb(alb_override_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_alb.md
    it { should exist }
    its('load_balancer_name') { should cmp 'kitchen-override' }
    its('state') { should include 'active' }
    its('scheme') { should cmp 'internet-facing' }
    its('security_groups') { should include sg_id }
    its('security_groups.count') { should be 1 }
    its('vpc_id') { should cmp vpc_id }
    its('type') { should eq 'application' }
    its('subnets.count') { should be >= 2 }
    its('zone_names.count') { should be >= 2 }
  end

  describe aws_alb(alb_80_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_alb.md
    it { should exist }
    its('load_balancer_name') { should cmp 'kitchen-80-alb' }
    its('state') { should include 'active' }
    its('scheme') { should cmp 'internet-facing' }
    its('security_groups') { should include sg_id }
    its('security_groups.count') { should be 1 }
    its('vpc_id') { should cmp vpc_id }
    its('type') { should eq 'application' }
    its('subnets.count') { should be >= 2 }
    its('zone_names.count') { should be >= 2 }
  end

  describe aws_elasticloadbalancingv2_target_group(alb_80_tg_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_target_group.md
    it { should exist }
    its('target_group_name') { should cmp 'kitchen-def-80-http-alb' }
    its('protocol') { should cmp 'HTTP' }
    its('port') { should cmp '80' }
    its('vpc_id') { should cmp vpc_id }
    its('health_check_enabled') { should eq true }
    its('health_check_interval_seconds') { should eq 30 }
    its('health_check_timeout_seconds') { should eq 5 }
    its('health_check_path') { should eq '/' }
    its('health_check_port') { should eq 'traffic-port' }
    its('health_check_protocol') { should eq 'HTTP' }
    its('healthy_threshold_count') { should eq 3 }
    its('unhealthy_threshold_count') { should eq 3 }
    its('target_type') { should eq 'instance' }
    its('matcher.http_code') { should eq '200' }
    its('load_balancer_arns') { should include alb_80_id }
  end

  describe aws_elasticloadbalancingv2_listener(alb_80_listener_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_listener.md
    it { should exist }
    its('port') { should eq 80 }
    its('protocol') { should eq 'HTTP' }
    its('default_actions.first.target_group_arn') { should eq alb_80_tg_id }
    its('default_actions.first.forward_config.target_groups.count') { should eq 1 }
    its('default_actions.first.forward_config.target_groups.first.target_group_arn') { should include alb_80_tg_id }
  end

  describe aws_alb(alb_443_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_alb.md
    it { should exist }
    its('load_balancer_name') { should cmp 'kitchen-443-alb' }
    its('state') { should include 'active' }
    its('scheme') { should cmp 'internet-facing' }
    its('security_groups') { should include sg_id }
    its('security_groups.count') { should be 1 }
    its('vpc_id') { should cmp vpc_id }
    its('type') { should eq 'application' }
    its('subnets.count') { should be >= 2 }
    its('zone_names.count') { should be >= 2 }
  end

  describe aws_elasticloadbalancingv2_target_group(alb_443_tg_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_target_group.md
    it { should exist }
    its('target_group_name') { should cmp 'kitchen-def-443-https-alb' }
    its('protocol') { should cmp 'HTTPS' }
    its('port') { should cmp '443' }
    its('vpc_id') { should cmp vpc_id }
    its('health_check_enabled') { should eq true }
    its('health_check_interval_seconds') { should eq 30 }
    its('health_check_timeout_seconds') { should eq 5 }
    its('health_check_path') { should eq '/' }
    its('health_check_port') { should eq 'traffic-port' }
    its('health_check_protocol') { should eq 'HTTP' }
    its('healthy_threshold_count') { should eq 3 }
    its('unhealthy_threshold_count') { should eq 3 }
    its('target_type') { should eq 'ip' }
    its('matcher.http_code') { should eq '200' }
    its('load_balancer_arns') { should include alb_443_id }
  end

  describe aws_elasticloadbalancingv2_listener(alb_443_listener_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_listener.md
    it { should exist }
    its('port') { should eq 443 }
    its('protocol') { should eq 'HTTPS' }
    its('default_actions.first.target_group_arn') { should eq alb_443_tg_id }
    its('default_actions.first.forward_config.target_groups.count') { should eq 1 }
    its('default_actions.first.forward_config.target_groups.first.target_group_arn') do
      should include alb_443_tg_id
    end
    its('certificates.first.certificate_arn') { should eq alb_443_listener_certificate_arn }
    its('ssl_policy') { should cmp 'ELBSecurityPolicy-TLS-1-2-Ext-2018-06' }
  end

  describe aws_alb(nlb_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_alb.md
    it { should exist }
    its('load_balancer_name') { should cmp 'kitchen-nlb' }
    its('state') { should include 'active' }
    its('scheme') { should cmp 'internet-facing' }
    its('vpc_id') { should cmp vpc_id }
    its('type') { should eq 'network' }
    its('subnets.count') { should be >= 2 }
    its('zone_names.count') { should be >= 2 }
  end

  describe aws_elasticloadbalancingv2_target_group(nlb_tg_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_target_group.md
    it { should exist }
    its('target_group_name') { should cmp 'kitchen-80-tcp-nlb' }
    its('protocol') { should cmp 'TCP' }
    its('port') { should cmp '80' }
    its('vpc_id') { should cmp vpc_id }
    its('health_check_enabled') { should eq true }
    its('health_check_interval_seconds') { should eq 30 }
    its('health_check_timeout_seconds') { should eq 10 }
    its('health_check_port') { should eq 'traffic-port' }
    its('health_check_protocol') { should eq 'TCP' }
    its('healthy_threshold_count') { should eq 3 }
    its('unhealthy_threshold_count') { should eq 3 }
    its('target_type') { should eq 'instance' }
    its('load_balancer_arns') { should include nlb_id }
  end

  describe aws_elasticloadbalancingv2_listener(nlb_listener_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_listener.md
    it { should exist }
    its('port') { should eq 80 }
    its('protocol') { should eq 'TCP' }
    its('default_actions.first.type') { should eq 'forward' }
    its('default_actions.first.target_group_arn') { should eq nlb_tg_id }
    its('default_actions.first.forward_config.target_groups.count') { should eq 1 }
    its('default_actions.first.forward_config.target_groups.first.target_group_arn') { should include nlb_tg_id }
  end

  describe aws_alb(nlb_80_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_alb.md
    it { should exist }
    its('load_balancer_name') { should cmp 'kitchen-80-nlb' }
    its('state') { should include 'active' }
    its('scheme') { should cmp 'internet-facing' }
    its('vpc_id') { should cmp vpc_id }
    its('type') { should eq 'network' }
    its('subnets.count') { should be >= 2 }
    its('zone_names.count') { should be >= 2 }
  end

  describe aws_elasticloadbalancingv2_target_group(nlb_80_tg_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_target_group.md
    it { should exist }
    its('target_group_name') { should cmp 'kitchen-def-80-tcp-nlb' }
    its('protocol') { should cmp 'TCP' }
    its('port') { should cmp '80' }
    its('vpc_id') { should cmp vpc_id }
    its('health_check_enabled') { should eq true }
    its('health_check_interval_seconds') { should eq 30 }
    its('health_check_timeout_seconds') { should eq 10 }
    its('health_check_port') { should eq 'traffic-port' }
    its('health_check_protocol') { should eq 'TCP' }
    its('healthy_threshold_count') { should eq 3 }
    its('unhealthy_threshold_count') { should eq 3 }
    its('target_type') { should eq 'instance' }
    its('load_balancer_arns') { should include nlb_80_id }
  end

  describe aws_elasticloadbalancingv2_listener(nlb_80_listener_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_listener.md
    it { should exist }
    its('port') { should eq 80 }
    its('protocol') { should eq 'TCP' }
    its('default_actions.first.type') { should eq 'forward' }
    its('default_actions.first.target_group_arn') { should eq nlb_80_tg_id }
    its('default_actions.first.forward_config.target_groups.count') { should eq 1 }
    its('default_actions.first.forward_config.target_groups.first.target_group_arn') { should include nlb_80_tg_id }
  end

  describe aws_alb(nlb_443_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_alb.md
    it { should exist }
    its('load_balancer_name') { should cmp 'kitchen-443-nlb' }
    its('state') { should include 'active' }
    its('scheme') { should cmp 'internet-facing' }
    its('vpc_id') { should cmp vpc_id }
    its('type') { should eq 'network' }
    its('subnets.count') { should be >= 2 }
    its('zone_names.count') { should be >= 2 }
  end

  describe aws_elasticloadbalancingv2_target_group(nlb_443_tg_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_target_group.md
    it { should exist }
    its('target_group_name') { should cmp 'kitchen-def-443-tls-nlb' }
    its('protocol') { should cmp 'TLS' }
    its('port') { should cmp '443' }
    its('vpc_id') { should cmp vpc_id }
    its('health_check_enabled') { should eq true }
    its('health_check_interval_seconds') { should eq 30 }
    its('health_check_timeout_seconds') { should eq 10 }
    its('health_check_port') { should eq 'traffic-port' }
    its('health_check_protocol') { should eq 'TCP' }
    its('healthy_threshold_count') { should eq 3 }
    its('unhealthy_threshold_count') { should eq 3 }
    its('target_type') { should eq 'instance' }
    its('load_balancer_arns') { should include nlb_443_id }
  end

  describe aws_elasticloadbalancingv2_listener(nlb_443_listener_id) do
    # https://github.com/inspec/inspec-aws/blob/main/docs/resources/aws_elasticloadbalancingv2_listener.md
    it { should exist }
    its('port') { should eq 443 }
    its('protocol') { should eq 'TLS' }
    its('default_actions.first.target_group_arn') { should eq nlb_443_tg_id }
    its('default_actions.first.forward_config.target_groups.count') { should eq 1 }
    its('default_actions.first.forward_config.target_groups.first.target_group_arn') do
      should include nlb_443_tg_id
    end
    its('certificates.first.certificate_arn') { should eq nlb_443_listener_certificate_arn }
    its('ssl_policy') { should cmp 'ELBSecurityPolicy-TLS-1-2-Ext-2018-06' }
  end
end
