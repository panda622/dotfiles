variable "token" {}
variable "thinkpad_keys" {}
variable "macbook_keys" {}
variable "mobile_keys" {}

variable "region" {
  default = "ap-south"
}

provider "linode" {
  token = var.token
}

resource "linode_instance" "dev" {
  image = "linode/ubuntu19.04"
  label = "DevMac"
  group = "self-learning"
  region = var.region
  type = "g6-standard-1"
  authorized_keys = [var.thinkpad_keys, var.macbook_keys, var.mobile_keys]

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
