output "db_endpoint" {
  description = "Endpoint do RDS (host:porta)"
  value       = aws_db_instance.oficina.endpoint
}

output "db_address" {
  description = "Apenas o host do RDS (sem porta)"
  value       = aws_db_instance.oficina.address
}

output "connection_string" {
  description = "Connection string pronta para usar em ConnectionStrings__DefaultConnection no K8s Secret"
  value       = "Server=${aws_db_instance.oficina.address},1433;Database=${var.db_name};User Id=${var.db_username};Password=${var.db_password};TrustServerCertificate=True;MultipleActiveResultSets=true"
  sensitive   = true
}
