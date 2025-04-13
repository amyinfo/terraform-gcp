
module "project_factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name                           = var.project_id      # 项目名称
  project_id                     = var.project_id      # 全局唯一的项目ID
  org_id                         = var.organization_id # amyinfo.com
  random_project_id              = false
  billing_account                = var.billing_account # 替换为你的结算账号
  enable_shared_vpc_host_project = true
}

module "buckets" {
  source = "./modules/buckets"

  tf_state_bucket = var.tf_state_bucket
}

module "sa-iam" {
  source = "./modules/sa-iam"

  project_id            = var.project_id
  service_account_roles = var.service_account_roles
}

module "network" {
  source = "./modules/network"
}
module "nat-gateway" {
  source  = "./modules/nat-gateway"
  vpc1    = module.network.vpc1
  vpc2    = module.network.vpc2
  subnet1 = module.network.subnet1
  subnet2 = module.network.subnet2
}
