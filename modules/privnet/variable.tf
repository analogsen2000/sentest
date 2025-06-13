variable privsn {
type = list
default = ["10.0.102.0/24", "10.0.110.0/24"]
}

variable myvpc {
default = "10.0.0.0/16"
}

variable privsgeg {
type = list
default = ["80", "8080", "443"]
}

variable privsgin {
type = list
default = ["22", "53"]
}

variable natipenable {
type = bool
default = "true"
}

variable externalip {
type = list
default = []
}

variable resuenatip {
type = bool
default = "false"
} 

variable pubsn {
type = list
default = ["10.0.101.0/24", "10.0.120.0/24"]
}
