output "app_server_ip" {
  value = module.compute.public_ips[0]
}

output "monitoring_server_ip" {
  value = module.compute.public_ips[1]
}
