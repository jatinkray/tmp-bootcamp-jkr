# Ooredoo Infrastructure Bootcamp 2026

This repository contains the Infrastructure as Code (IaC) and Helm charts for the Ooredoo Fintech International Infrastructure Bootcamp. It automates the deployment of a managed Kubernetes cluster (AKS), a PostgreSQL database, and a full observability stack.

## 🚀 Quick Start Guide

### 1. Prerequisites
Ensure you have the following tools installed:
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/quick-start/)
- [Helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

### 2. Environment Setup
Create a `.env` file in the root directory with your Azure Service Principal credentials:
```bash
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```
*Note: The `.env` file is git-ignored for security.*

### 3. Deploy Infrastructure
Initialize and apply the Terraform configuration using Terragrunt:
```bash
source .env
terragrunt apply
```
This will provision:
- **Resource Group:** `Bootcamp`
- **AKS Cluster:** Managed Kubernetes with Nginx Ingress enabled.
- **PostgreSQL:** Flexible Server (Minimum size) for Grafana backend.

### 4. Configure Kubernetes Access
Retrieve the cluster credentials:
```bash
source .env
az aks get-credentials --resource-group Bootcamp --name $(terragrunt output -raw aks_cluster_name) --overwrite-existing
```

### 5. Deploy Applications (Helm)
Deploy the monitoring and GitOps stacks:

**Monitoring (Prometheus + Grafana + Postgres Exporter):**
```bash
# Update dependencies
helm dependency update charts/monitoring

# Create secret for DB access
kubectl create namespace monitoring
kubectl create secret generic grafana-db-creds \
  --from-literal=GF_DATABASE_PASSWORD=$(terragrunt output -raw postgres_password) \
  -n monitoring

# Install
helm upgrade --install monitoring ./charts/monitoring -n monitoring
```

**ArgoCD:**
```bash
helm dependency update charts/argocd
helm upgrade --install argocd ./charts/argocd -n argocd --create-namespace
```

### 6. Access the Dashboard
Find the Public IP of the Nginx Ingress Controller:
```bash
kubectl get service -n app-routing-system
```
Access Grafana at: `http://<EXTERNAL-IP>/`

---

## 🏗️ Architecture decisions
- **Modular IaC:** Terraform code is split into reusable modules under `modules/`.
- **Managed Ingress:** Uses the AKS `web_app_routing` add-on for a managed Nginx Ingress experience.
- **External Backend:** Grafana is configured to store its state in the Azure PostgreSQL instance.
- **Networking:** Default networking is used for simplicity in this bootcamp. See [ADR 0001](./adr/0001-no-vnet-for-bootcamp.md) for details.

## 📄 Documentation
- [Module Reference](./docs/modules.md)
- [Architecture Decisions (ADR)](./adr/)
