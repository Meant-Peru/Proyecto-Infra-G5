// AKS
resource_group_name = "rg-appg5-dev-west-01"
location            = "West US"
aks_name            = "aks-appg5-dev-west-01"
dns_prefix          = "aksdns"
node_count          = 2
node_vm_size        = "Standard_a2_v2"
environment         = "Development"
environment_short   = "dev"

// SQL Database
sql_admin_username = "sqladmin"
sql_admin_password = "P@ssw0rd123!Change" # CAMBIAR ESTO por un valor seguro
sql_sku_name       = "Basic"

//PROVIDER
subscription_id     = "bb916693-00a9-495b-b74b-a92340d2d6a8"
