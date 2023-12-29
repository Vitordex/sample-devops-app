variable "application_credential_id" {
  type = string
}

variable "application_credential_secret" {
  type = string
}

variable "environment" {
  type = string
  default = "dev"
}

variable "ssh_ip_prefix" {
  type = string
  default = "0.0.0.0/0"
}
