variable "KEYNAME" {
  type    = string
  default = "n8n"
}

variable "REGION" {
  type    = string
  default = "us-west-2"
}
variable "AZ" {
  type    = string
  default = "us-west-2a"
}

variable "IPADDRESS" {
  type    = string
  default = "1.2.3.4"
}

variable "DOCKERCOMPOSEFILE" {
  type    = string
  default = "n8n.docker-compose-staging.yaml"
}

variable "ELASTICIPALLOC" {
  type    = string
  default = "eipalloc-myalloc"
}

variable "DATAFOLDER" {
  type    = string
  default = "/home/ec2-user/n8n/"
}

variable "DOMAIN" {
  type    = string
  default = "mydomain.com"
}

variable "SUBDOMAIN" {
  type    = string
  default = "n8n"
}

variable "BASICAUTHUSER" {
  type    = string
  default = "myname"
}

variable "BASICAUTHPASSWORD" {
  type    = string
  default = "3a2d-sample-password-5c6d7717e6b"
}

variable "TIMEZONE" {
  type    = string
  default = "America/Los_Angeles"
}

variable "EMAIL" {
  type    = string
  default = "email@mydomain.com"
}
