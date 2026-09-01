# Usa a VPC e subnets default da conta — o AWS Academy Learner Lab normalmente
# não permite criar VPCs customizadas nem roles/usuários IAM novos, então esta
# abordagem funciona tanto em uma conta AWS pessoal quanto no Learner Lab.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "oficina" {
  name       = "oficina-wagyu-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Projeto = "OficinaMecanicaWagyu"
  }
}

resource "aws_security_group" "rds" {
  name        = "oficina-wagyu-rds-sg"
  description = "Permite conexao ao RDS SQL Server (porta 1433)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SQL Server"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Projeto = "OficinaMecanicaWagyu"
  }
}

resource "aws_db_instance" "oficina" {
  identifier     = "oficina-wagyu-db"
  engine         = "sqlserver-ex" # SQL Server Express — free tier eligible, compatível com o EF Core SqlServer provider já usado na aplicação
  engine_version = "15.00"
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp2"

  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.oficina.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = true # simplifica o acesso do cluster K3s durante o desenvolvimento; pode ser restringido depois
  skip_final_snapshot  = true
  multi_az             = false

  tags = {
    Projeto = "OficinaMecanicaWagyu"
    Fase     = "3"
  }
}
