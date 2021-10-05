provider "azurerm" {
  version = "=2.78.0"
  features {}
}

####################
#### RG ############
####################
resource "azurerm_resource_group" "primary_rgweb" {
  name                          = "${var.primaryResourcePrefix}-web-rg"
  location                      = var.primaryLocation
}
resource "azurerm_resource_group" "secondary_rgweb" {
  name                          = "${var.secondaryResourcePrefix}-web-rg"
  location                      = var.secondaryLocation
}
resource "azurerm_resource_group" "primary_rgvault" {
  name                          = "${var.primaryResourcePrefix}-security-rg"
  location                      = var.primaryLocation
}
resource "azurerm_resource_group" "secondary_rgvault" {
  name                          = "${var.secondaryResourcePrefix}-security-rg"
  location                      = var.secondaryLocation
}
resource "azurerm_resource_group" "rgdb" {
  name                          = "${var.primaryResourcePrefix}-db-rg"
  location                      = var.primaryLocation
}
resource "azurerm_resource_group" "rgstorage" {
  name                          = "${var.primaryResourcePrefix}-storage-rg"
  location                      = var.primaryLocation
}
resource "azurerm_resource_group" "rgwaf" {
  name                          = "${var.globalResourcePrefix}-waf-rg"
  location                      = var.primaryLocation
}
