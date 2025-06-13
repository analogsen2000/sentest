resource "aws_launch_template" nl {
image_id = var.img
instance_type = var.insty
key_name = var.kn
vpc_security_group_ids = var.sg
}

resource "aws_autoscaling_group" nlg {
vpc_zone_identifier = var.vz
min_size = "1"
max_size = "1"
desired_capacity = "1"
health_check_type = "EC2"
health_check_grace_period = "30"
launch_template {
id = aws_launch_template.nl.id
}

initial_lifecycle_hook {
name = "nlgt"
default_result = "CONTINUE"
heartbeat_timeout = "30"
lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
}
}

resource aws_autoscaling_policy nloi {
name = "nlplm"
autoscaling_group_name = aws_autoscaling_group.nlg.name
policy_type            = "TargetTrackingScaling"
   target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}
