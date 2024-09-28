output "public_ip_address" {
  value = [for instance in aws_instance.example : instance.public_ip]
}

output "instance_data" {
  value = [for instance in aws_instance.example : instance]
}