# Automated Deployment of SonarQube with PostgreSQL Using Terraform

## Introduction
This guide details the automated setup of SonarQube with a PostgreSQL database using Terraform. The complete project is hosted at [one-acre-fund/sonarqube-terraform](git@github.com:one-acre-fund/sonarqube-terraform.git).

## Requirements
Terraform v1.6.2 or later.  
Access to an Hcloud provider.  
A pre-configured PostgreSQL database for SonarQube.  

## Database Configuration for SonarQube

Before deploying SonarQube, configure a compatible database. This tutorial uses PostgreSQL, but you can apply these steps to other databases, adjusting for their specific syntax and practices.

### PostgreSQL Setup Instructions:

- Initiate a new SonarQube database.  
- Create a user `sonarqube_user` with a robust password to handle database operations for SonarQube.  
- Provide `sonarqube_user` with full database management rights.  
- Optionally assign ownership of the database to `sonarqube_user` for enhanced control.  
- Establish a `sonarqube_ro_user` for read-only tasks, such as reporting.  

Execute these PostgreSQL commands:

```sql
-- Create SonarQube database  
CREATE DATABASE "sonarqube";

-- Create primary user with a secure password  
CREATE USER sonarqube_user WITH PASSWORD 'sonarqube_password';

-- Grant complete privileges on the database  
GRANT ALL PRIVILEGES ON DATABASE "sonarqube" TO sonarqube_user;

-- Optionally designate the user as the database owner  
ALTER DATABASE "sonarqube" OWNER TO sonarqube_user;

-- Establish a read-only user  
CREATE USER sonarqube_ro_user WITH PASSWORD 'some_secure_password';

-- Assign read-only privileges  
GRANT CONNECT ON DATABASE "sonarqube" TO sonarqube_ro_user;
GRANT USAGE ON SCHEMA public TO sonarqube_ro_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO sonarqube_ro_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO sonarqube_ro_user;
```

### Alternative Database Options:

For different databases, consult their respective documentation for specific setup and configuration instructions.

## Installation Steps
Clone the repository:
```
git clone git@github.com:one-acre-fund/sonarqube-terraform.git
```
Navigate to the cloned directory:
```
cd sonarqube-terraform
```
Initialize Terraform:
```
terraform init
```

## Usage
Customize `variables.tf` according to your needs. To preview the deployment, execute:
```
terraform plan
```
To apply the configuration:
```
terraform apply
```
Confirm the changes as prompted by Terraform.

## Outputs
After deployment, `outputs.tf` provides essential details like the SonarQube server's IP, DNS name, and database connection information.

## Configuration Variables
Variables in the Terraform configuration are categorized as follows:

### Hetzner Cloud Configuration
`hetzner_cloud_api_token`: API Token for Hetzner Cloud (Sensitive)  

### SSH Configuration
`ssh_public_key_name`: SSH Public Key name  
`ssh_private_key_path`: Path to SSH Private Key (Sensitive)  
`ssh_user`: SSH username for server access  
`ssh_user_password`: SSH user password (Sensitive)  

### Server Configuration
`server_datacenter`: Datacenter location, e.g., `hel1-dc2`  
`server_image`: Server image, e.g., `ubuntu-22.04`  
`server_type`: Server type, e.g., `cax11`  
`server_name`: Server name  

### SonarQube Configuration
Refer to [SonarQube Database Configuration Documentation](https://docs.sonarqube.org/latest/setup/install-server/) for detailed settings.

`sonarqube_admin_password`: Password for the SonarQube Administrator  
`sonarqube_db_host`: SonarQube database URL  
`sonarqube_db_port`: Database port, e.g., `5432`  
`sonarqube_db_name`: SonarQube database name  
`sonarqube_db_username`: Database username  
`sonarqube_db_password`: Database password (Sensitive)  
`sonarqube_domain_name`: SonarQube server domain name  

### TLS Certificate Configuration
`tls_certificates_base_path`: Path to TLS certificates and keys  

You can customize variables using `terraform.tfvars`.  
For instance:

```
hetzner_cloud_api_token = "my-hcloud-api-token"
ssh_public_key_name = "my-ssh-key"
...
```

This guide provides a comprehensive and step-by-step approach to seamlessly deploy SonarQube using Terraform and integrate it with a PostgreSQL database, ensuring a smooth and efficient setup process.