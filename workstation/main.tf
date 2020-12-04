variable "root_pass" {}
variable "linode_token" {}
variable "id_linode_pub" {}

terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.13.4"
    }
  }
}


provider "linode" {
	linode_token = var.linode_token
}

resource "linode_instance" "dev" {
	label = "base"
	image = "linode/ubuntu20.04"
	group = "sudo"
	region = "ap-south"
	type = "g6-nanode-1"
	authorized_keys = [var.id_linode_pub]

	provisioner "file" {
		source      = "setup.sh"
		destination = "/tmp/setup.sh"

		connection {
			type        = "ssh"
			user        = "root"
			private_key = file("~/.ssh/id_linode")
			host        = self.ip_address
		}
	}

	provisioner "remote-exec" {
		inline = [
			"chmod +x /tmp/setup.sh",
			"/tmp/setup.sh",
		]

		connection {
			type        = "ssh"
			user        = "root"
			private_key = file("~/.ssh/id_linode")
			host        = self.ip_address
		}
	}
}

output "public_ip" {
  value = linode_instance.dev.ip_address
}
