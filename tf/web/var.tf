variable "resourcePrefix" {
  type = string
}
variable "location" {
  type = string
}
variable "rgName" {
  type = string
}
variable "storageName" {
  type = string
}
variable "storageKey" {
  type = string
}
variable "shareName" {
  type = string
}
variable "containerName" {
  type = string
}
variable "blobName" {
  type = string
}
variable "sasKey" {
  type = string
  sensitive = true
}
variable "dbHost" {
  type = string
  sensitive = true
}
variable "dbName" {
  type = string
  sensitive = true
}
variable "identity" {
  type = string
}
variable "secretUriUser" {
  type = string
}
variable "secretUriPass" {
  type = string
}

