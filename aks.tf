locals {
  idapp = "AppG5" # Apellido
}

resource "azurerm_resource_group" "rg_01" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks_01" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg_01.location
  resource_group_name = azurerm_resource_group.rg_01.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }
  
  tags = {
    Environment = var.environment
  }

  role_based_access_control_enabled = true
}

## ACR
resource "azurerm_container_registry" "acr" {
   name = "acr${local.idapp}"
   location = azurerm_resource_group.rg_01.location  
   resource_group_name = azurerm_resource_group.rg_01.name 
   sku = "Basic" 
   admin_enabled = false 
   }

## Dar permiso al AKS para extraer imágenes del ACR 
resource "azurerm_role_assignment" "aks_acr" { 
  principal_id = azurerm_kubernetes_cluster.aks_01.kubelet_identity[0].object_id 
  role_definition_name = "AcrPull" 
  scope = azurerm_container_registry.acr.id 
  }

## Configuración del proveedor Kubernetes
output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_01.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_01.kube_config_raw

  sensitive = true
}