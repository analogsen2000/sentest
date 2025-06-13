resource aws_security_group sg {
vpc_id = var.vpc

dynamic egress {
for_each = var.eg
content {
from_port = egress.value
to_port = egress.value
protocol = "tcp"
description = "outbound traffic"
cidr_blocks = ["0.0.0.0/0"]
}
}

dynamic ingress {
for_each = var.ing
content {
description = "inboud traffic"
from_port = ingress.value.port
to_port = ingress.value.port
protocol = ingress.value.protocol
cidr_blocks = ["0.0.0.0/0"]
}
}
}

resource aws_elb elb {
security_groups = [aws_security_group.sg.id]
subnets = var.sn

dynamic listener {
for_each = var.lr
content {
lb_port = listener.value["lport"]
lb_protocol = listener.value["lprotocol"]
instance_port = listener.value["iport"]
instance_protocol = listener.value["iprotocol"]
}
}

health_check {
healthy_threshold = lookup(var.hc, "healthy_threshold")
interval = lookup(var.hc, "interval")
target = lookup(var.hc, "target")
timeout = lookup(var.hc, "timeout") 
unhealthy_threshold = lookup(var.hc, "unhealthy_threshold")
}
}


resource aws_launch_template nl {
image_id = var.img
instance_type = var.insty
key_name = var.kn
vpc_security_group_ids = [aws_security_group.sg.id]
}

resource aws_autoscaling_group ag {
vpc_zone_identifier = var.sn
load_balancers = [aws_elb.elb.id]
min_size = "1"
max_size = "1"
desired_capacity = "1"
health_check_type = "EC2"
health_check_grace_period = 30
initial_lifecycle_hook {
    name = "test"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 60
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
}

launch_template {
id = aws_launch_template.nl.id
}

}

resource aws_autoscaling_policy apnl {
name = "testac"
autoscaling_group_name = aws_autoscaling_group.ag.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
   target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}


