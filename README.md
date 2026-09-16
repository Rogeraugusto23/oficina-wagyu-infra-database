# oficina-wagyu-infra-database

Infraestrutura como código (Terraform) do banco de dados gerenciado da **Oficina Mecânica Wagyu** — Tech Challenge Fase 3.

## O que este repositório provisiona

- Instância **RDS SQL Server Express** (`db.t3.micro`, free tier eligible)
- Security Group liberando a porta `1433` para o cluster Kubernetes
- Subnet Group usando a VPC/subnets default da conta (compatível com AWS Academy Learner Lab)

## Pré-requisitos

- Terraform >= 1.6
- Credenciais AWS configuradas (via `aws configure` ou variáveis de ambiente — incluindo `AWS_SESSION_TOKEN` se usando AWS Academy Learner Lab)

## Como provisionar

```bash
cp example.tfvars terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Outputs

```bash
terraform output -raw connection_string
```

## Notas sobre AWS Academy Learner Lab

As credenciais do Learner Lab expiram periodicamente. Se um `terraform plan`/`apply` falhar com erro de autenticação expirada, gere novas credenciais na aba **AWS Details** do laboratório.

## ✅ Status: testado e validado em produção

- **RDS ativo e em uso**: `oficina-wagyu-db.c3r6kcfknndv.us-east-1.rds.amazonaws.com`
- Conectado com sucesso pela aplicação principal (rodando em Kubernetes) e pela Lambda de autenticação via CPF — ambas consultam e gravam dados neste banco em produção.
- Migrations do Entity Framework Core aplicadas automaticamente no primeiro start da aplicação (`Database.Migrate()`), incluindo a coluna `Ativo` na tabela `Clientes`, adicionada na Fase 3 para suportar a checagem de status feita pela Lambda.
