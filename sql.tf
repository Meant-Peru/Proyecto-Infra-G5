## Azure SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = "sql-${lower(local.idapp)}-${var.environment_short}"
  resource_group_name          = azurerm_resource_group.rg_01.name
  location                     = azurerm_resource_group.rg_01.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"

  tags = {
    Environment = var.environment
  }
}

## Azure SQL Database
resource "azurerm_mssql_database" "inventory_db" {
  name           = "InventarioDB"
  server_id      = azurerm_mssql_server.sql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  sku_name       = var.sql_sku_name
  max_size_gb    = 2
  zone_redundant = false

  tags = {
    Environment = var.environment
  }
}

## Firewall rule para permitir servicios de Azure
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

## Output del connection string
output "sql_connection_string" {
  value     = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.inventory_db.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive = true
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}
