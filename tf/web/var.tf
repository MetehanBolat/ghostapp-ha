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
  description = "Used for persistance storage settings for Azure Files"
}
variable "storageKey" {
  type = string
  description = "Used for persistance storage settings for Azure Files"
}
variable "shareName" {
  type = string
  description = "Used for persistance storage settings for Azure Files"
}
variable "containerName" {
  description = "Used as a package location for function app, together with blobName"
  type = string
}
variable "blobName" {
  description = "Used as a package location for function app, together with containerName"
  type = string
}
variable "sasKey" {
  description = "Used as a package location for function app, together with blobName and containerName"
  type = string
  sensitive = true
}
variable "dbHost" {
  description = "Used for App Settings, for mySQL Host"
  type = string
  sensitive = true
}
variable "dbName" {
  description = "Used for App Settings, for mySQL Database Name"
  type = string
  sensitive = true
}
variable "identity" {
  description = "Used for App Service Identity - with Get Secret rights"
  type = string
}
variable "secretUriUser" {
  description = "Used for App Settings - MySQL User"
  type = string
}
variable "secretUriPass" {
  description = "Used for App Settings - MySQL Password"
  type = string
  sensitive = true
}
variable "aiKey" {
  description = "Used for App Settings - Application Insights InstrumentationKey"
  type = string
}
variable "aiConnectionString" {
  description = "Used for App Settings - Application Insights ConnectionString"
  type = string
}

