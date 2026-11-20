output "aws_region" {
  description = "Región de AWS"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Nombre del clúster EKS"
  value       = module.eks.cluster_name
}

output "ecr_repository_url" {
  description = "URL del repositorio de imágenes"
  value       = aws_ecr_repository.api.repository_url
}

output "github_ecr_push_role_arn" {
  description = "Rol que asume el pipeline de la API para publicar imágenes (variable AWS_ECR_ROLE_ARN)"
  value       = aws_iam_role.github_ecr_push.arn
}

output "github_deploy_role_arn" {
  description = "Rol que asume el pipeline de despliegue (variable AWS_DEPLOY_ROLE_ARN)"
  value       = aws_iam_role.github_deploy.arn
}

output "configure_kubectl" {
  description = "Comando para conectar kubectl al clúster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
