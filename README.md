# Automated AWS Log Backup Infrastructure

A production-ready AWS infrastructure provisioned via **Terraform** to automate log collection and archival. This project demonstrates cloud networking, security, and automation practices.

## 🏗️ Architecture Overview

The system architecture consists of a two-tier network:

- **Public Subnet:** Hosts a Web Server with restricted SSH access.
- **Private Subnet:** Hosts a Backup Server that securely fetches logs and uploads them to S3.
- **Security:** Uses IAM Roles (no hardcoded keys), NAT Gateway for private egress, and S3 Gateway Endpoints for secure data transfer.

![Architecture Diagram](architecture.png)

## 🚀 Key Features

- **Infrastructure as Code (IaC):** Complete VPC setup using Terraform.
- **High Security:** EC2 instances use IAM Instance Profiles with least-privilege S3 policies.
- **Network Optimization:** Traffic to S3 stays within the AWS network via VPC Endpoints.
- **Automated Pipeline:** Bash scripts triggered by Crontab for daily log rotation and S3 syncing.
- **Data Durability:** S3 Bucket versioning enabled to prevent data loss.

## 🛠️ Tech Stack

- **Cloud:** AWS (VPC, EC2, S3, NAT Gateway, IAM)
- **IaC:** Terraform
- **Scripting:** Bash, Crontab
- **OS:** Amazon Linux 2023

## 📖 How to Deploy

1. Clone the repository
2. Initialize Terraform
