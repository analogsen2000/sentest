resource aws_instance new_ec {
for_each = { for x, i in var.inp : x => i }

ami = each.value.img
instance_type = each.value.insty

tag = {
name = "jenkins-slave"
}

key_name = var.kn
security_groups = var.sg
}
