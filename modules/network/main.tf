# modulul de retea: VCN + subnet public + internet gateway + security list

resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "${var.project_name}-vcn"
  dns_label      = "mainvcn"
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-igw"
  enabled        = true
}

resource "oci_core_route_table" "main" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.main.id
  }
}

# security list - aici e partea de firewall la nivel de cloud
# regula: SSH doar de la IP-ul tau, HTTP/HTTPS deschise public, restul blocat
resource "oci_core_security_list" "main" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.project_name}-seclist"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    source   = var.my_ip_cidr
    protocol = "6" # TCP
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6"
    tcp_options {
      min = 443
      max = 443
    }
  }

  # port pentru Netdata / Prometheus - restrictionat tot la IP-ul tau
  ingress_security_rules {
    source   = var.my_ip_cidr
    protocol = "6"
    tcp_options {
      min = 19999
      max = 19999
    }
  }
}

resource "oci_core_subnet" "public" {
  compartment_id             = var.compartment_ocid
  vcn_id                      = oci_core_vcn.main.id
  cidr_block                  = "10.0.1.0/24"
  display_name                = "${var.project_name}-public-subnet"
  dns_label                   = "public"
  route_table_id               = oci_core_route_table.main.id
  security_list_ids            = [oci_core_security_list.main.id]
  prohibit_public_ip_on_vnic  = false
}
