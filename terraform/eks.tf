module "eks" {
  # checkov:skip=CKV_TF_1:Módulo oficial del Terraform Registry fijado por versión
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.30"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.admin_cidrs

  # Registros del plano de control: quién llamó a la API de Kubernetes y qué hizo
  cluster_enabled_log_types              = ["api", "audit", "authenticator"]
  cloudwatch_log_group_retention_in_days = 7

  # Quien ejecuta Terraform queda como administrador del clúster
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      # Habilita el cumplimiento de NetworkPolicy en el clúster
      configuration_values = jsonencode({
        enableNetworkPolicy = "true"
      })
    }
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa.iam_role_arn
    }
  }

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.node_instance_types
      capacity_type  = "SPOT"

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }

  # El pipeline de despliegue solo puede administrar el namespace de la aplicación
  access_entries = {
    github_deploy = {
      principal_arn = aws_iam_role.github_deploy.arn

      policy_associations = {
        app_namespace = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            type       = "namespace"
            namespaces = ["contracts"]
          }
        }
      }
    }
  }
}

module "ebs_csi_irsa" {
  # checkov:skip=CKV_TF_1:Módulo oficial del Terraform Registry fijado por versión
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "${var.project_name}-ebs-csi-"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}
