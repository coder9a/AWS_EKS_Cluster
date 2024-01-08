# Infrastructure Deployment with Terraform
![eks drawio](https://github.com/coder9a/AWS_EKS_Cluster/assets/42884781/e505ae55-b8a2-490c-b5d1-09a0d0339856)
![image](https://github.com/coder9a/AWS_EKS_Cluster/assets/42884781/cdb30cf2-abb3-47fd-ba3c-b10e6ea90d6e)

Provisioning production-ready Amazon Elastic Kubernetes Service (EKS) clusters using Terraform.
This Terraform script deploys a Kubernetes infrastructure on AWS with the following components:

## 1. VPC

### 1.1 Public Subnet

A public subnet within the Virtual Private Cloud (VPC) to accommodate resources accessible from the internet.

### 1.2 Private Subnet

A private subnet within the VPC to host resources that should not be directly accessible from the internet.

### 1.3 Internet Gateway

An Internet Gateway attached to the VPC to enable communication between the VPC and the internet.

### 1.4 Elastic IP

Elastic IP for providing a static public IP address to resources in the VPC.

### 1.5 Nat Gateway

Network Address Translation (NAT) Gateway to allow private subnet resources to initiate outbound traffic to the internet.

## 2. EKS ControlPlane

### 2.1 Create Role for Accessing Master Node

An IAM role that grants permissions to access the EKS control plane (master nodes).

### 2.2 Security Group for Master Node

A security group defining inbound and outbound rules for securing communication with the EKS control plane.

### 2.3 Inbound Rule for Worker Node Interaction

Inbound rule allowing worker nodes to interact with the EKS control plane.

### 2.4 Outbound Rule for Internet Access

Outbound rule allowing the EKS control plane to communicate with the internet.

## 3. Worker Node

### 3.1 Create Role for Accessing Worker Node

An IAM role that grants permissions to access worker nodes.

### 3.2 Security Group for Worker Node

A security group defining inbound and outbound rules for securing communication with worker nodes.

### 3.3 Inbound Rule for Master Node Interaction

Inbound rule allowing the EKS control plane to interact with worker nodes.

