terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
#variable "do_token" {}
#provider "digitalocean" {
#  token = var.do_token
#}


variable "region" {
  default = "sgp1"
}

resource "digitalocean_volume" "dev" {
  name                    = "dev"
  region                  = "${var.region}"
  size                    = 20
  initial_filesystem_type = "ext4"
  description             = "volume for dev"

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_droplet" "cloud" {
  name               = "cloud"
  image              = "ubuntu-20-04-x64"
  size               = "s-4vcpu-8gb"
  region             = "${var.region}"
  backups            = false
  ipv6               = false
  ssh_keys           = [34022586]                        # doctl compute ssh-key list
  volume_ids         = ["${digitalocean_volume.dev.id}"]

  provisioner "file" {
    source      = "../setup.sh"
    destination = "/tmp/setup.sh"

    connection {
      host        =  "${digitalocean_droplet.cloud.ipv4_address}"
      type        = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh initialize",
    ]

    connection {
      type        = "ssh"
      host        =  "${digitalocean_droplet.cloud.ipv4_address}"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "10m"
    }
  }
}

resource "digitalocean_firewall" "dev" {
  name = "dev"

  droplet_ids = ["${digitalocean_droplet.cloud.id}"]

  inbound_rule {
      protocol         = "udp"
      port_range       = "60000-60010"
      source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule  {
      protocol              = "tcp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule  {
      protocol              = "udp"
      port_range            = "1-65535"
      destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule  {
      protocol              = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "public_ip" {
  value = "${digitalocean_droplet.cloud.ipv4_address}"
}

