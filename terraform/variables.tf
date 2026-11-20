variable "aws_region" {
  description = "Región de AWS donde se crea la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre base de los recursos"
  type        = string
  default     = "contracts-pricing"
}

variable "github_owner" {
  description = "Usuario u organización de GitHub dueña de los repositorios"
  type        = string
  default     = "migueflorez10"
}

variable "app_repository" {
  description = "Repositorio de la API, autorizado para publicar imágenes en ECR"
  type        = string
  default     = "contracts-pricing-api"
}

variable "infra_repository" {
  description = "Repositorio de infraestructura, autorizado para desplegar en EKS"
  type        = string
  default     = "contracts-pricing-infra"
}

variable "cluster_version" {
  description = "Versión de Kubernetes del clúster. Nulo usa la versión por defecto de EKS."
  type        = string
  default     = null
}

variable "node_instance_types" {
  description = "Tipos de instancia para los nodos (Spot)"
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "admin_cidrs" {
  description = "Rangos IP autorizados para administrar el clúster por su endpoint público"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "monthly_budget_usd" {
  description = "Presupuesto mensual en dólares para la alerta de costos"
  type        = number
  default     = 20
}

variable "budget_alert_email" {
  description = "Correo que recibe las alertas de presupuesto"
  type        = string
}
