output "sonarqube_server_ips" {
  value = hcloud_server.sonarqube_servers[*].ipv4_address
}