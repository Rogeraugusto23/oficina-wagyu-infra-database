variable "aws_region" {
  description = "Região AWS. No AWS Academy Learner Lab, geralmente é fixa em us-east-1."
  type        = string
  default     = "us-east-1"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "OficinaMecanicaDB"
}

variable "db_username" {
  description = "Usuário administrador do banco"
  type        = string
  default     = "admin_wagyu"
}

variable "db_password" {
  description = "Senha do administrador do banco (defina via TF_VAR_db_password ou terraform.tfvars — NUNCA commitar em texto puro)"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe da instância RDS (free tier: db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "allowed_cidr" {
  description = "CIDR autorizado a acessar o banco (ex: o CIDR da VPC onde roda o K3s). Restrinja em produção."
  type        = string
  default     = "0.0.0.0/0" # ⚠️ Ajuste depois de criar o repo de infra-k8s, apontando só para o SG/CIDR do cluster
}
