variable "hcloud_token" {
  description = "API Token for Hetzner Cloud"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH Key"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH Private Key file"
  type        = string
  sensitive   = true
}

variable "sonar_admin_username" {
  description = "SonarQube Admin Username"
  type        = string
}

variable "sonar_admin_password" {
  description = "SonarQube Admin Password"
  type        = string
}

variable "server_count" {
  description = "Number of servers to deploy"
  type        = number
  default     = 1
}

variable "datacenter" {
  description = "Datacenter to deploy the server in"
  type        = string
  default     = "hel1-dc2"
}

variable "image" {
  description = "Image to deploy on the server"
  type        = string
  default     = "ubuntu-22.04"
}

variable "server_type" {
  description = "Type of server to deploy"
  type        = string
  default     = "cx21"
}

variable "db_url" {
  description = "Database URL for SonarQube"
  type        = string
}

variable "db_name" {
  description = "Database Name for SonarQube"
  type        = string
}

variable "db_username" {
  description = "Database Username for SonarQube"
  type        = string
}

variable "db_password" {
  description = "Database Password for SonarQube"
  type        = string
}
