resource "aws_ecr_repository" "api" {
  name = var.app_repository

  # Una etiqueta publicada no se puede sobrescribir: cada imagen queda ligada a un commit
  image_tag_mutability = "IMMUTABLE"

  # Permite destruir el entorno de demostración aunque tenga imágenes
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  # Cifrado con la llave KMS administrada por AWS (aws/ecr): sin costo mensual de llave propia
  encryption_configuration {
    encryption_type = "KMS"
  }
}

resource "aws_ecr_lifecycle_policy" "api" {
  repository = aws_ecr_repository.api.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Conservar solo las 20 imágenes más recientes"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 20
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
