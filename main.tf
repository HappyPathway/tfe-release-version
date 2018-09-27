variable "service_name" {
    default = "simple-app"
}

variable "allowed_versions" {
    default = ["1.0.0"]
    type = "list"
    description = "list of allowed versions"
}

variable "set_version" {
    default = true
}

variable "enforce_version" {}

variable "env" {}

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
    path    = "${var.service_name}/${var.env}/allowed_versions"
    default = "${var.allowed_versions}"
  }
}

resource "consul_keys" "app" {
  count = "${var.set_version ? 1 : 0 }"
  datacenter = "${var.consul_dc}"
  # token      = "abcd"

  # Set the CNAME of our load balancer as a key
  key {
    path    = "${var.service_name}/${var.env}/allowed_versions"
    value = "${var.allowed_versions}"
  }
  
  key {
    path    = "${var.service_name}/${var.env}/enforce_version"
    value = "${var.enforce_version}"
  }
}
    
output "allowed_versions" {
    value = "${var.set_version ? var.allowed_versions : data.consul_key_prefix.app.var.allowed_versoins}"
}

output "service_name" {
    value = "${var.service_name}"
}

output "enforce_version" {
    value = "${var.enforce_version}"
}

output "env" {
    value = "${var.env}"
}
