terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.44.1"
    }
  }
  required_version = ">= 1.6.2"
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "sonarqube_servers" {
  count       = var.server_count
  name        = "sonarqube-server-${count.index + 1}"
  image       = var.image
  datacenter  = var.datacenter
  server_type = var.server_type
  ssh_keys    = [var.ssh_key_name]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker run -d --name sonarqube -p 9000:9000  -e SONARQUBE_JDBC_URL=${var.db_url}/${var.db_name}  -e SONARQUBE_JDBC_USERNAME=${var.db_username}  -e SONARQUBE_JDBC_PASSWORD=${var.db_password}  -e SONAR_SECURITY_USERLOGIN=${var.sonar_admin_username}  -e SONAR_SECURITY_USERPASSWORD=${var.sonar_admin_password}  sonarqube"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key_path)
      host        = self.ipv4_address
    }
  }
}
