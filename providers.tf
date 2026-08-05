terraform {
  required_version = ">= 1.5.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }

  # backend "remote" {
  #   organization = "your-org-name"
  #   workspaces {
  #     name = "oci-terraform-ansible"
  #   }
  # }
  # dezactivat deocamdata, ramane local pana cand merita mutat state-ul in remote
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
