# modulul compute: instante VM.Standard.A1.Flex (ARM, Always Free)
# data source-ul de mai jos ia automat cea mai recenta imagine Ubuntu, ca sa nu ramana un OCID hardcodat care expira

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "node" {
  count               = var.instance_count
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "${var.project_name}-${var.instance_names[count.index]}"
  shape                = "VM.Standard.A1.Flex"

  shape_config {
    # Always Free total: 4 OCPU / 24GB RAM impartite in functie de numarul de instante
    ocpus         = var.ocpus_per_instance
    memory_in_gbs = var.memory_per_instance
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }
}
