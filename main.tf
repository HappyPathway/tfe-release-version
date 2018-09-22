variable "service_name" {
    default = "simple-app"
}

variable "service_version" {
    default = "1.0.0"
}

variable "set_version" {
    default = true
}

variable "consul_cluster" {}

variable "consul_dc" {}

provider "consul" {
  address    = "${var.consul_cluster}"
  datacenter = "${var.consul_dc}"
}

data "consul_key_prefix" "app" {
  datacenter = "${var.consul_dc}"
  # token      = "abcd"

  # Prefix to add to prepend to all of the subkey names below.
  path_prefix = "app/deployments"

  # Read the release version
  subkey {
    name    = "release_version"
    path    = "${var.service_name}/release_version"
    default = "${var.service_version}"
  }
}

resource "consul_keys" "app" {
  count = "${var.set_version ? 1 : 0 }"
  datacenter = "${var.consul_dc}"
  # token      = "abcd"

  # Set the CNAME of our load balancer as a key
  key {
    path    = "${var.service_name}/release_version"
    value = "${var.service_version}"
  }
}
    
output "release_version" {
    value = "${var.set_version ? var.service_version : data.consul_key_prefix.app.var.release_version}"
}

