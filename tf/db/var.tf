variable "resourcePrefix" {
  type = string
}
variable "location" {
  type = string
}
variable "rgName" {
  type = string
}
variable "adminName" {
  type = string
  sensitive = true
}
variable "adminPass" {
  type = string
  sensitive = true
}