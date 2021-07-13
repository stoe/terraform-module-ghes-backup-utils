output "instance_id" {
  description = "The instance ID"
  value       = aws_instance.backup_utils.id
}

output "subnet_id" {
  description = "The instance subnet ID"
  value       = aws_instance.backup_utils.subnet_id
}

output "private_ip" {
  description = "The instance private IP"
  value       = aws_instance.backup_utils.private_ip
}

output "public_ip" {
  description = "The instance public IP"
  value       = aws_eip.backup_utils_eip.public_ip
}
