module "network" {
  source = "./modules/network"

  compartment_ocid = var.compartment_ocid
  project_name      = var.project_name
  my_ip_cidr        = var.my_ip_cidr
}

module "compute" {
  source = "./modules/compute"

  compartment_ocid    = var.compartment_ocid
  project_name        = var.project_name
  subnet_id           = module.network.subnet_id
  ssh_public_key_path = var.ssh_public_key_path
}

# genereaza automat inventory-ul Ansible din output-ul Terraform
# asa nu mai scrii IP-uri manual - sursa unica de adevar e Terraform
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory.ini"
  content  = <<-EOT
    [app_server]
    ${module.compute.public_ips[0]} ansible_user=ubuntu

    [monitoring_server]
    ${module.compute.public_ips[1]} ansible_user=ubuntu

    [all:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOT
}
