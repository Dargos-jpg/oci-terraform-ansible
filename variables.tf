# autentificare OCI - completezi cu valorile din API Keys (Identity & Security)
variable "tenancy_ocid" {
  description = "OCID-ul tenancy-ului OCI"
  type        = string
}

variable "user_ocid" {
  description = "OCID-ul userului tau OCI"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint-ul cheii API generate in Console"
  type        = string
}

variable "private_key_path" {
  description = "Calea locala catre fisierul .pem privat (NU se comite in git)"
  type        = string
}

variable "region" {
  description = "Regiunea OCI (ex: eu-frankfurt-1)"
  type        = string
}

variable "compartment_ocid" {
  description = "OCID-ul compartimentului in care creezi resursele (root compartment la inceput e ok)"
  type        = string
}

# configurare generala proiect
variable "project_name" {
  description = "Prefix folosit la denumirea resurselor"
  type        = string
  default     = "oci-terraform-ansible"
}

variable "ssh_public_key_path" {
  description = "Calea catre cheia SSH publica folosita pentru acces pe VM-uri"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "my_ip_cidr" {
  description = "IP-ul tau public in format CIDR (ex: 82.77.XX.XX/32) - singurul IP cu voie sa faca SSH"
  type        = string
}
