variable "keyname" {
  type    = string
  default = "n8n"
}

variable "region" {
  type    = string
  default = "us-west-2"
}
variable "az" {
  type    = string
  default = "us-west-2a"
}

variable "ipaddress" {
  type    = string
  default = "1.2.3.4"
}

variable "dockercomposefile" {
  type    = string
  default = "n8n.docker-compose-staging.yaml"
}

variable "elasticipalloc" {
  type    = string
  default = "eipalloc-myalloc"
}
