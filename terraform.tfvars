// AKS
resource_group_name = "rg-appg5-dev-west-01"
location            = "West US"
aks_name            = "aks-appg5-dev-west-01"
dns_prefix          = "aksdns"
node_count          = 2
node_vm_size        = "Standard_a2_v2"
environment         = "Development"

//PROVIDER
subscription_id     = "bb916693-00a9-495b-b74b-a92340d2d6a8"
