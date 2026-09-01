# oficina-wagyu-infra-database

Infraestrutura como código (Terraform) do banco de dados gerenciado da
**Oficina Mecânica Wagyu** — Tech Challenge Fase 3.

## O que este repositório provisiona

- Instância **RDS SQL Server Express** (`db.t3.micro`, free tier eligible)
- Security Group liberando a porta `1433` para o cluster Kubernetes
- Subnet Group usando a VPC/subnets **default** da conta (compatível com as
  restrições do AWS Academy Learner Lab, que não permite criar VPCs novas
  nem usuários/roles IAM customizados)

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.6
- Credenciais AWS configuradas (via `aws configure` ou variáveis de ambiente
  `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` — esta
  última é obrigatória se você estiver usando o **AWS Academy Learner Lab**,
  que gera credenciais temporárias)

## Como provisionar

```bash
cp example.tfvars terraform.tfvars
# edite terraform.tfvars e defina uma senha forte

terraform init
terraform plan
terraform apply
```

## Outputs

Depois do `apply`, pegue a connection string para configurar no repositório
`oficina-wagyu-infra-k8s` (como valor do Secret da aplicação):

```bash
terraform output -raw connection_string
```

## Arquitetura

```
┌─────────────────────────────┐
│      VPC Default (AWS)      │
│                              │
│   ┌──────────────────────┐  │
│   │  RDS SQL Server       │  │
│   │  (db.t3.micro)        │◄─┼── Security Group: porta 1433
│   │  oficina-wagyu-db      │  │   liberada para o cluster K3s
│   └──────────────────────┘  │
└─────────────────────────────┘
```

## Notas sobre AWS Academy Learner Lab

As credenciais do Learner Lab expiram periodicamente (geralmente a cada 4h de
sessão). Se um `terraform plan`/`apply` falhar com erro de autenticação
expirada, gere novas credenciais na aba **AWS Details** do laboratório e
reexporte as variáveis de ambiente antes de tentar novamente.
