variable "pve_pass" {
  type    = string
  default = "Houska2023"
  sensitive = true
}

variable "example_count" {
  type    = number
  default = 1
}

variable "example_enabled" {
  type    = bool
  default = true
}