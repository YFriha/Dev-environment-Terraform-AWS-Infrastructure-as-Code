# Dev-environment-Terraform-AWS-Infrastructure-as-Code
Terraform script to provision a VPC, public subnet, EC2 instance, and networking components on AWS for development purposes.
# 🛠️ Terraform AWS Infrastructure - Dev Environment

This project contains Terraform code to provision a simple development environment on AWS. It sets up:

- A Virtual Private Cloud (VPC)
- A public subnet
- An internet gateway
- A route table and its association
- A security group allowing all traffic
- An EC2 instance
- SSH key pair for access

---

🚀 Infrastructure Overview

🔧 VPC
- CIDR block: `10.123.0.0/16`
- DNS support enabled

🌐 Public Subnet
- CIDR block: `10.123.1.0/24`
- Public IP on launch enabled

🌉 Internet Gateway
- Attached to the VPC

🛣️ Route Table
- Routes 0.0.0.0/0 traffic via the internet gateway
- Associated with the public subnet

🔐 Security Group
- Allows all inbound and outbound traffic (for development/testing use only)

💻 EC2 Instance
- Instance type: `t3.micro`
- Launched in the public subnet
- Uses the specified key pair for SSH access
- Includes user data from `userdata.tpl`

---

📁 Project Structure

.
├── main.tf # Main Terraform configuration
├── output.tf 
├── datasource.tf 
├── userdata.tpl # EC2 user data script (shell script)
├── ssh-config.tpl # SSH config template (used by local-exec provisioner)
└── README.md # Project documentation
---

✅ Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- AWS CLI configured with appropriate credentials
- A public SSH key at `~/.ssh/mtckey.pub`

---

🧪 Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name
Initialize Terraform:

bash
Copy
Edit
terraform init
Review the plan:

bash
Copy
Edit
terraform plan
Apply the infrastructure:

bash
Copy
Edit
terraform apply
Confirm with yes when prompted.
