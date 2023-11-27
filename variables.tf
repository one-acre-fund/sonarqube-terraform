# Hetzner Cloud Configuration
variable "hetzner_cloud_api_token" {
  description = "API Token for Hetzner Cloud"
  type        = string
  sensitive   = true
}

# SSH Configuration
variable "ssh_public_key_name" {
  description = "Name of the SSH Public Key"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH Private Key file"
  type        = string
  sensitive   = true
}

variable "ssh_user" {
  description = "SSH username to be added to the server for SSH access"
  type        = string
}

variable "ssh_user_password" {
  description = "Password for the SSH user"
  type        = string
  sensitive   = true
}

# Server Configuration
variable "server_datacenter" {
  description = "Datacenter to deploy the server in"
  type        = string
}

variable "server_image" {
  description = "Image to deploy on the server"
  type        = string
}

variable "server_type" {
  description = "Type of server to deploy"
  type        = string
}

variable "server_name" {
  description = "Name of the server"
  type        = string
}

# SonarQube Configuration
variable "sonarqube_admin_password" {
  description = "Password for the SonarQube Administrator"
  type        = string
  sensitive   = true
}

variable "sonarqube_db_host" {
  description = "Database URL for SonarQube"
  type        = string
}

variable "sonarqube_db_port" {
  description = "Database Port for SonarQube"
  type        = number
  default     = 5432
}

variable "sonarqube_db_name" {
  description = "Database Name for SonarQube"
  type        = string
}

variable "sonarqube_db_username" {
  description = "Database Username for SonarQube"
  type        = string
}

variable "sonarqube_db_password" {
  description = "Database Password for SonarQube"
  type        = string
  sensitive   = true
}

variable "sonarqube_domain_name" {
  description = "Domain Name for the SonarQube Server"
  type        = string
}

# TLS Certificate Configuration
variable "tls_certificates_base_path" {
  description = "Base path to the folder containing TLS certificates and keys"
  type        = string
}
