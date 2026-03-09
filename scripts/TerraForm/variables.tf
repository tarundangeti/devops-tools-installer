
variable "fruits" {

  type = list(string)

  default = ["apple", "banana", "mango"]

}

variable "veggs" {
  type    = list(string)
  default = ["carrot", "onions", "tomatos"]
}

variable "keys" {
  type = list(string)

  default = ["name", "age"]

}

variable "value" {
  type    = list(string)
  default = ["tarun", "26"]


}

variable "my_map" {
  type    = map(string)
  default = { "name" = "tarun", "age" = "26" }
}

variable "my_set" {
  type    = set(string)
  default = ["arun", "ram", "seetha", "laxman", "hanuman"]
}

variable "instance_tags" {
  default = {
    Name = "webserver"
    Env  = "production"
  }

}

output "myoutput" {

  #value = length(var.fruits)
  #value = concat(var.fruits, var.veggs)
  #value = element(var.fruits, 2)

  #value = zipmap(var.keys, var.value)
  #value = lookup(var.my_map, "name")
  #value = join(",", var.fruits)
  #value = tolist(var.my_set)

  #value = var.instance_tags["Name"]

  value = var.instance_tags
}


output "set_output" {


  value = keys(var.instance_tags)

}

output "values_output" {

  value = values(var.instance_tags)
}
