# Automated AWS Log Backup Infrastructure

A simple cloud project where I built an AWS infrastructure using **Terraform** to automate collecting server logs and storing them in S3.

The goal of this project was to practice real DevOps and Cloud concepts like networking, automation, and Infrastructure as Code.

---

## 🏗️ Architecture Overview

The infrastructure consists of:

- **Public Subnet**
  - EC2 Web Server hosting the application

- **Private Subnet**
  - EC2 Backup Server responsible for collecting logs

- **S3 Bucket**
  - Used to store compressed logs backups

- **NAT Gateway**
  - Allows the private instance to access the internet securely

- **S3 Gateway Endpoint**
  - Allows private network access to S3 without using the internet

![AWS Architecture](architecture.png)

---

## ⚙️ Workflow

1. Users access the website hosted on the **Web Server (EC2)**.
2. The **Backup Server** runs a scheduled **cron job**.
3. The script connects to the Web Server via **SSH**.
4. Logs are collected and compressed using `tar.gz`.
5. The compressed logs are uploaded automatically to **Amazon S3**.

---

## 🚀 Key Features

- Infrastructure fully provisioned using **Terraform**
- Secure access using **IAM Roles (no hardcoded credentials)**
- Private subnet architecture with **NAT Gateway**
- **Automated log backup** using Bash and Cron
- Logs archived and stored in **Amazon S3**
- **S3 Bucket Versioning** enabled for data durability

---

## 🛠️ Tech Stack

- **Cloud:** AWS (VPC, EC2, S3, NAT Gateway, IAM)
- **Infrastructure as Code:** Terraform
- **Automation:** Bash Scripts & Cron
- **Operating System:** Amazon Linux 2023

---

## 📦 Project Structure
