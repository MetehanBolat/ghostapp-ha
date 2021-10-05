variable "globalResourcePrefix" {
  type = string
}
variable "rgName" {
  type = string
}

variable "primaryUrl" {
  description = "Primary URL for loadbalancing endpoint01"
  type = string
}
variable "secondaryUrl" {
  description = "Secondary URL for loadbalancing endpoint01"
  type = string
}
