output "public_ip" {
  value = module.ec2_module.public_ip_address
}

output "availability_zone" {
  value = module.ec2_module.instance_data[*].availability_zone
}