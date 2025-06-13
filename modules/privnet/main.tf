resource aws_vpc myvpc {
cidr_block = var.myvpc
}

data aws_availability_zones az {
}

resource aws_internet_gateway igw {
count = length(var.privsn) > 0 ? 1 : 0
vpc_id = aws_vpc.myvpc.id
}

resource aws_subnet pubsn {
count = length(var.pubsn)
cidr_block = element(var.pubsn, count.index)
vpc_id = aws_vpc.myvpc.id
availability_zone = data.aws_availability_zones.az.names[count.index]
}

resource aws_subnet privsn {
count = length(var.privsn)
vpc_id = aws_vpc.myvpc.id
cidr_block = element(var.privsn, count.index)
availability_zone = data.aws_availability_zones.az.names[count.index]
}

resource aws_route_table rtpriv {
count = length(var.privsn) > 0 ? 1 : 0
vpc_id = aws_vpc.myvpc.id
}

resource aws_route_table_association rtapriv {
count = length(var.privsn)
subnet_id = element(aws_subnet.privsn.*.id, count.index)
route_table_id = aws_route_table.rtpriv[0].id
}

resource aws_security_group privsg {
vpc_id = aws_vpc.myvpc.id

dynamic egress {
for_each = var.privsgeg
content {
from_port = egress.value
to_port = egress.value
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}

dynamic ingress {
for_each = var.privsgin
content {
from_port = ingress.value
to_port = ingress.value
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}
}

locals {
nat_ip = var.resuenatip ? var.externalip : try(aws_eip.natip[*].id)
}

resource aws_eip natip {
count = var.natipenable && length(var.privsn) > 0 ? 1 : 0
domain = "vpc"
depends_on = [aws_internet_gateway.igw]
}

resource aws_nat_gateway mynat {
count = var.natipenable && length(var.privsn) > 0 ? 1 : 0
allocation_id = element(local.nat_ip, count.index)
subnet_id = aws_subnet.pubsn[0].id
}

resource aws_route rte_priv {
count = var.natipenable && length(var.privsn) > 0 ? 1 : 0
route_table_id = aws_route_table.rtpriv[0].id
destination_cidr_block = "0.0.0.0/0"
nat_gateway_id = aws_nat_gateway.mynat[0].id
}
 
