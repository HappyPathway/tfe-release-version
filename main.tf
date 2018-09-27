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

resource "random_id" "random" {
  keepers {
    uuid = "${uuid()}"
  }
  byte_length = 32
}
    
output "allowed_versions" {
    value = "${var.allowed_versions}"
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

output "service_version_validator" {
    value = "true"
}
