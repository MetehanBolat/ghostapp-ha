provider "azurerm" {
  version = "=2.78.0"
  features {}
}
#######################
# ApplicationInsights #
#######################

resource "azurerm_application_insights" "ai" {
  name                = "${var.resourcePrefix}-ai"
  location            = var.location
  resource_group_name = var.rgName
  application_type    = "web"
}