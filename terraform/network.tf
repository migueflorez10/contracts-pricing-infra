locals {
  # Zonas fijas: el resultado no cambia si AWS agrega zonas nuevas en la región
  azs          = ["${var.aws_region}a", "${var.aws_region}b"]
  cluster_name = "${var.project_name}-eks"
}

module "vpc" {
  # checkov:skip=CKV_TF_1:Módulo oficial del Terraform Registry fijado por versión
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.8"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"
  azs  = local.azs

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # Un solo NAT Gateway para reducir costos en un entorno de demostración
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Registro del tráfico de red para auditoría
  enable_flow_log                                 = true
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_cloudwatch_log_group_retention_in_days = 7

  # Etiquetas que usa Kubernetes para ubicar los balanceadores de carga
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
