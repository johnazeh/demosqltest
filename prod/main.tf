# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  
}

resource "azurerm_resource_group" "rg" {
  name     = "TerraformRG"
  location = "CanadaCentral"
}

resource "azurerm_sql_server" "sql" {
  name                         = "truprod02"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = "CanadaCentral"
  version                      = "12.0"
  administrator_login          = "john.azeh"
  administrator_login_password = "Password010101"
}

resource "azurerm_sql_firewall_rule" "sql" {
  name                = "AlllowAzureServices"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sql.name
  start_ip_address    = "108.173.224.177"
  end_ip_address      = "108.173.224.177"
}

resource "azurerm_sql_elasticpool" "elp" {
  name                = "trudevelasticpool"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "CanadaCentral"
  server_name         = azurerm_sql_server.sql.name
  edition             = "Basic"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 5
  pool_size           = 5000
}

resource "azurerm_sql_database" "sql" {
  name                 = "AdventureWorks2017"
  resource_group_name  = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name          = azurerm_sql_server.sql.name
    
}

resource "azurerm_storage_account" "stor" {
  name                     = "prodjemadevaccount"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = "CanadaCentral"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_storage_container" "cont" {
  name                  = "prodconcc01"
  storage_account_name  = azurerm_storage_account.stor.name
  container_access_type = "private"
}

#resource "azurerm_data_factory" "adf" {
 # name                = "jemazodevadf"
 # location            = "CanadaCentral"
 # resource_group_name = azurerm_resource_group.rg.name
#}




