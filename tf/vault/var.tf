variable "resourcePrefix" {
  type = string
}
variable "location" {
  type = string
}
variable "rgName" {
  type = string
}
variable "serverName" {
  description = "Used as a value for mysql-user secret"
  type = string
}
variable "adminName" {
  description = "Used as a value for mysql-user secret"
  type = string
  sensitive = true
}
variable "adminPass" {
  description = "Used as a value for mysql-password secret"
  type = string
  sensitive = true
}