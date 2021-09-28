## common variables
variable "resourcePrefix" {
  type = string
}
variable "location" {
  type = string
}
## variables for storage module
variable "storageName" {
  type = string
}
## variables for DB module
variable "adminName" {
  type = string
}
variable "adminPass" {
  type = string
}