provider "azurerm" {
  version = "=2.78.0"
  features {}
}

####################
#### RG ############
####################
resource "azurerm_resource_group" "rg" {
  name                          = "${var.resourcePrefix}-rg"
  location                      = var.location
}
resource "azurerm_resource_group" "rgweb" {
  name                          = "${var.resourcePrefix}-web-rg"
  location                      = var.location
}
resource "azurerm_resource_group" "rgdb" {
  name                          = "${var.resourcePrefix}-db-rg"
  location                      = var.location
}