# ADR 0001: Use of Default Networking instead of Virtual Network (VNet)

## Status
Accepted

## Context
In a standard production-grade Azure deployment, it is a best practice to deploy resources like AKS and PostgreSQL Flexible Server within a Virtual Network (VNet). This provides:
- Network isolation.
- Private communication between the cluster and database via delegated subnets.
- Enhanced security via Network Security Groups (NSGs).

However, this is an **Infrastructure Bootcamp/Test** environment intended for rapid prototyping and validation of core concepts.

## Decision
We have decided to forgo the creation of a Virtual Network (VNet) and associated networking components (subnets, private DNS zones, NSGs) at this stage.

## Rationale
1. **Simplicity:** Reduces the complexity of the Infrastructure as Code (IaC), making it easier for bootcamp participants to follow the core logic of cluster and database provisioning.
2. **Speed of Deployment:** Avoids the time-consuming process of setting up subnet delegation and Private DNS Zone propagation, which can be brittle in a test environment.
3. **Connectivity:** Communication between AKS and PostgreSQL will be facilitated using the "Allow access to Azure services" firewall toggle, which is sufficient for non-production validation.

## Consequences
- **Security:** Resources are theoretically reachable via public endpoints (though protected by passwords/identities).
- **Architecture:** The current IAC does not reflect a production-ready "Hub-and-Spoke" model.
- **Future Work:** If this project transitions to a production environment, a full network refactoring will be required.
