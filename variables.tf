// AKS

variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
  default     = "rg-appg5-dev-west-01"
}

variable "location" {
  description = "Ubicación donde se desplegarán los recursos"
  type        = string
  default     = "West US"
}

variable "aks_name" {
  description = "Nombre del AKS cluster"
  type        = string
  default     = "aks-appg5-dev-west-01"
}

variable "dns_prefix" {
  description = "Prefijo DNS para el AKS"
  type        = string
  default     = "aksdns"
}

variable "node_count" {
  description = "Número de nodos en el pool"
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "Tamaño de la VM en el node pool"
  type        = string
  default     = "Standard_a2_v2"
}

variable "environment" {
  description = "Etiqueta de entorno"
  type        = string
  default     = "Development"
}

variable "environment_short" {
  description = "Nombre corto del entorno (dev, qa, prd)"
  type        = string
  default     = "dev"
}

// SQL Database

variable "sql_admin_username" {
  description = "Usuario administrador de SQL Server"
  type        = string
  default     = "sqladmin"
  sensitive   = true
}

variable "sql_admin_password" {
  description = "Contraseña del administrador de SQL Server"
  type        = string
  sensitive   = true
}

variable "sql_sku_name" {
  description = "SKU de la base de datos SQL"
  type        = string
  default     = "Basic"
}

//PROVIDER

variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

