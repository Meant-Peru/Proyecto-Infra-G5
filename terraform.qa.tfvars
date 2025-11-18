# Configuración para QA

// AKS
resource_group_name = "rg-appg5-qa-west-01-AppG5"
location            = "West US"
aks_name            = "aks-appg5-qa-west-01-AppG5"
dns_prefix          = "aksdns-qa"
node_count          = 2
node_vm_size        = "Standard_a2_v2"
environment         = "QA"
environment_short   = "qa"

// SQL Database
sql_admin_username = "sqladmin"
# La contraseña debe pasarse como variable de entorno: TF_VAR_sql_admin_password
sql_sku_name       = "Basic"

//PROVIDER
subscription_id     = "bb916693-00a9-495b-b74b-a92340d2d6a8"
