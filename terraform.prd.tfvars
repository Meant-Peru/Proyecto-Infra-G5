# Configuración para PRD

// AKS
resource_group_name = "rg-appg5-prd-west-01-AppG5"
location            = "West US"
aks_name            = "aks-appg5-prd-west-01-AppG5"
dns_prefix          = "aksdns-prd"
node_count          = 2
node_vm_size        = "Standard_a2_v2"  # Igual que QA por limite de quota
environment         = "Production"
environment_short   = "prd"

// SQL Database
sql_admin_username = "sqladmin"
# La contraseña debe pasarse como variable de entorno: TF_VAR_sql_admin_password
sql_sku_name       = "S0"  # SKU más robusto para producción

//PROVIDER
subscription_id     = "bb916693-00a9-495b-b74b-a92340d2d6a8"
