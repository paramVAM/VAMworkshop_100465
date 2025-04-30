# Compute module - outputs.tf

output "instance_ids" {
  description = "IDs of created instances"
  value       = aws_instance.app_servers[*].id
}

output "instance_public_ips" {
  description = "Public IPs of created instances"
  value       = aws_instance.app_servers[*].public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.instance_sg.id
}