Automated AWS Log Backup Infrastructure
A production-ready AWS environment provisioned via Terraform to automate log collection and archival. This project demonstrates high-level cloud networking, security, and DevOps automation practices.

🏗️ Architecture Overview
The system is built on a two-tier network design to ensure maximum security:

Public Subnet: Hosts the Web Server with restricted SSH access (limited to specific IP).

Private Subnet: Hosts the Backup Server, isolated from direct internet access.

Data Flow: The Backup Server fetches logs via SSH, compresses them, and syncs them to S3 using a private VPC Gateway Endpoint to keep traffic off the public internet.

🌟 Key Features
Infrastructure as Code (IaC): Entire VPC stack, including Subnets, NAT Gateways, and Route Tables, managed via Terraform.

Identity & Security: Leverages IAM Instance Profiles to grant EC2 instances secure access to S3 without using hardcoded credentials.

Network Optimization: Uses an S3 VPC Endpoint to reduce data transfer costs and increase security.

Automated Pipeline: Custom Bash scripts triggered by Crontab for automated daily compression, rotation, and cloud synchronization.

Data Durability: S3 Versioning is enabled to protect against accidental deletions and ensure recovery.

🛠️ Tech Stack
Cloud Platform: AWS (VPC, EC2, S3, NAT Gateway, IAM)

IaC Tool: Terraform

OS & Scripting: Amazon Linux 2023, Bash, Cron Jobs

🚀 How to Deploy
Clone the repository.

Initialize the environment: terraform init.

Preview the infrastructure: terraform plan.

Deploy to AWS: terraform apply.
