variable myvpc {
default = "10.0.0.0/16"
}

variable pubsn {
type = list
default = ["10.0.101.0/24", "10.0.120.0/24"]
}

variable pubsgeg {
type = list
default = ["80", "8080", "443"]
}

variable pubsgin {
type = list
default = ["22", "3089"]
}


