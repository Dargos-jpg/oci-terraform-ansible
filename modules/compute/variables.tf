variable "compartment_ocid" {
  type = string
}

variable "project_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "instance_names" {
  type    = list(string)
  default = ["app-server", "monitoring-server"]
}

# Always Free total = 4 OCPU / 24GB pentru toate instantele A1 combinate
# cu 2 instante: 2 OCPU / 12GB fiecare ramane in limita gratuita
variable "ocpus_per_instance" {
  type    = number
  default = 2
}

variable "memory_per_instance" {
  type    = number
  default = 12
}
