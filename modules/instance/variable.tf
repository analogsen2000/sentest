variable inp {
type = list(map(string))
default = [
#{img = "ami-0f535a71b34f2d44a", insty = "t2.medium" },
{img = "0e35ddab05955cf57", insty = "t2.micro" },
#{img = "ami-09299e47e83cceaa7", insty = "t2.micro" },
#{img = "ami-09299e47e83cceaa7", insty = "t2.medium" }
]
}

variable kn {
default = "Terrafom_test"
}

variable sg {
type = list(string)
default = ["sg-0ec636f3f2480ce67"]
}
