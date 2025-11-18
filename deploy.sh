#!/bin/bash
set -e

# Script de deployment de infraestructura con Terraform
# Uso: ./deploy.sh [dev|qa|prd] [plan|apply|destroy]

ENVIRONMENT=$1
ACTION=${2:-plan}

if [ -z "$ENVIRONMENT" ]; then
    echo "Error: Debes especificar un ambiente (dev, qa, prd)"
    echo "Uso: ./deploy.sh [dev|qa|prd] [plan|apply|destroy]"
    exit 1
fi

if [[ ! "$ENVIRONMENT" =~ ^(dev|qa|prd)$ ]]; then
    echo "Error: Ambiente inválido. Usa: dev, qa, o prd"
    exit 1
fi

if [[ ! "$ACTION" =~ ^(plan|apply|destroy)$ ]]; then
    echo "Error: Acción inválida. Usa: plan, apply, o destroy"
    exit 1
fi

echo "Iniciando deployment de infraestructura"
echo "   Ambiente: $ENVIRONMENT"
echo "   Acción: $ACTION"
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "aks.tf" ]; then
    echo "Error: No se encuentra aks.tf. Ejecuta este script desde Proyecto-Infra-G5/"
    exit 1
fi

# Verificar Azure CLI
if ! command -v az &> /dev/null; then
    echo "Error: Azure CLI no está instalado"
    exit 1
fi

# Verificar Terraform
if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform no está instalado"
    exit 1
fi

# Verificar login en Azure
echo "🔐 Verificando sesión de Azure..."
if ! az account show &> /dev/null; then
    echo "No estás autenticado en Azure. Ejecuta: az login"
    exit 1
fi

# Verificar que TF_VAR_sql_admin_password esté configurado
if [ -z "$TF_VAR_sql_admin_password" ]; then
    echo "Advertencia: TF_VAR_sql_admin_password no está configurado"
    read -sp "Ingresa la contraseña de SQL Server: " SQL_PASSWORD
    echo ""
    export TF_VAR_sql_admin_password="$SQL_PASSWORD"
fi

# Inicializar Terraform si no está inicializado
if [ ! -d ".terraform" ]; then
    echo "🔧 Inicializando Terraform..."
    terraform init
fi

# Seleccionar o crear workspace
if [ "$ENVIRONMENT" != "dev" ]; then
    echo "🔀 Seleccionando workspace: $ENVIRONMENT"
    terraform workspace select "$ENVIRONMENT" 2>/dev/null || terraform workspace new "$ENVIRONMENT"
fi

TFVARS_FILE="terraform.${ENVIRONMENT}.tfvars"

if [ ! -f "$TFVARS_FILE" ]; then
    echo "Error: No se encuentra el archivo $TFVARS_FILE"
    exit 1
fi

echo "📄 Usando archivo de variables: $TFVARS_FILE"
echo ""

case $ACTION in
    plan)
        echo "Ejecutando plan..."
        terraform plan -var-file="$TFVARS_FILE"
        ;;
    apply)
        echo "Aplicando cambios..."
        terraform apply -var-file="$TFVARS_FILE"

        if [ $? -eq 0 ]; then
            echo ""
            echo "Infraestructura desplegada exitosamente"
            echo ""
            echo "Outputs importantes:"
            echo "   SQL Connection String:"
            terraform output sql_connection_string
            echo ""
            echo "   SQL Server FQDN:"
            terraform output sql_server_fqdn
        fi
        ;;
    destroy)
        echo "ADVERTENCIA: Vas a destruir toda la infraestructura de $ENVIRONMENT"
        read -p "¿Estás seguro? (escribe 'yes' para confirmar): " CONFIRM

        if [ "$CONFIRM" = "yes" ]; then
            echo "💥 Destruyendo infraestructura..."
            terraform destroy -var-file="$TFVARS_FILE"
        else
            echo "Operación cancelada"
            exit 1
        fi
        ;;
esac

echo ""
echo "✨ Completado"
