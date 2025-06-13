variable vpc {
default = "vpc-0832ab24b4e348032"
}

variable eg {
type = list
default = ["80", "8080", "443"]
}

variable sn {
type = list
default = ["subnet-0683c14cda64ab22d"]
}

variable ing {
type = list(map(string))
default = [{
"port" = "22"
"protocol" = "tcp"
},
{
"port" = "3389"
"protocol" = "tcp"
},
]
}

variable lr {
type = list(map(string))
default = [{
iport = "80"
iprotocol = "http"
lprotocol = "http"
lport = "8080"
},
{
iport = "443"
iprotocol = "http"
lport = "443"
lprotocol = "http"
}
]
}

variable hc {
type = map(string)
default = {
healthy_threshold = 3
interval = 20
target = "TCP:80"
timeout = 5
unhealthy_threshold = 6
}
}

variable img {
default = "ami-0e35ddab05955cf57"
}

variable insty {
default = "t2.micro"
}

variable kn {
default = "Terrafom_test"
}
