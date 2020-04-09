variable "root_pass" {}
variable "token" {}
variable "thinkpad_keys" {}
provider "linode" {
	token = var.token
}

resource "linode_instance" "dev" {
	label = "dev-machine"
	image = "linode/arch"
	group = "sudo"
	region = "ap-south"
	type = "g6-nanode-1"
	authorized_keys = [var.thinkpad_keys]

	provisioner "file" {
		source      = "setup.sh"
		destination = "/tmp/setup.sh"

		connection {
			type        = "ssh"
			user        = "root"
			private_key = file("~/.ssh/id_rsa")
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
			private_key = file("~/.ssh/id_rsa")
			host        = self.ip_address
		}
	}
}

output "public_ip" {
  value = "${linode_instance.dev.ip_address}"
}
