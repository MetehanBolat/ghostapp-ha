## common variables
variable "globalResourcePrefix" {
  type = string
}
variable "primaryResourcePrefix" {
  type = string
}
variable "secondaryResourcePrefix" {
  type = string
}
variable "primaryLocation" {
  type = string
}
variable "secondaryLocation" {
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