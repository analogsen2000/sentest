resource aws_vpc myvpc {
cidr_block = var.myvpc
enable_dns_hostnames = true
}

resource aws_internet_gateway igw {
count = length(var.pubsn) > 0 ? 1 : 0
vpc_id = aws_vpc.myvpc.id
}

data aws_availability_zones az {
}

resource aws_subnet pubsn {
count = length(var.pubsn)
vpc_id = aws_vpc.myvpc.id
cidr_block = element(var.pubsn, count.index)
availability_zone = data.aws_availability_zones.az.names[count.index]
}

resource aws_route_table rt {
count = length(var.pubsn) > 0 ? 1 : 0
vpc_id = aws_vpc.myvpc.id
}

resource aws_route_table_association rta {
count = length(var.pubsn)
subnet_id = element(aws_subnet.pubsn.*.id, count.index)
route_table_id = aws_route_table.rt[0].id
}

resource aws_route rte {
route_table_id = aws_route_table.rt[0].id
destination_cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw[0].id
}

resource aws_security_group pubsg {
count = length(var.pubsn) > 0 ? 1 : 0
vpc_id = aws_vpc.myvpc.id

dynamic egress {
for_each = var.pubsgeg
content {
from_port = egress.value
to_port = egress.value
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}

dynamic ingress {
for_each = var.pubsgin
content {
from_port = ingress.value
to_port = ingress.value
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}
}

resource aws_security_group_rule sgr {
security_group_id = aws_security_group.pubsg[0].id
type = "egress"
from_port = 135
to_port = 135
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

