output "public_ips" {
  value = oci_core_instance.node[*].public_ip
}

output "instance_names" {
  value = oci_core_instance.node[*].display_name
}
