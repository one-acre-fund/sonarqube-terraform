terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.44.1"
    }
  }
  required_version = ">= 1.6.2"
}

provider "hcloud" {
  token = var.hetzner_cloud_api_token
}

locals {
  script_args = [
    var.ssh_user,
    var.ssh_user_password,
    var.sonarqube_admin_password,
    var.sonarqube_db_host,
    var.sonarqube_db_port,
    var.sonarqube_db_name,
    var.sonarqube_db_username,
    var.sonarqube_db_password,
    var.sonarqube_domain_name
  ]
}

resource "hcloud_server" "sonarqube_server" {
  name        = var.server_name
  image       = var.server_image
  datacenter  = var.server_datacenter
  server_type = var.server_type
  ssh_keys    = [var.ssh_public_key_name]

  provisioner "file" {
    source      = "scripts/setup_sonarqube.sh"
    destination = "/tmp/setup_sonarqube.sh"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key_path)
      host        = self.ipv4_address
    }
  }

  provisioner "file" {
    source      = "${var.tls_certificates_base_path}/tls.crt"
    destination = "/etc/ssl/certs/tls.crt"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key_path)
      host        = self.ipv4_address
    }
  }

  provisioner "file" {
    source      = "${var.tls_certificates_base_path}/tls.pem"
    destination = "/etc/ssl/private/tls.pem"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key_path)
      host        = self.ipv4_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup_sonarqube.sh",
      "/tmp/setup_sonarqube.sh ${join(" ", local.script_args)}"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key_path)
      host        = self.ipv4_address
    }
  }
}
