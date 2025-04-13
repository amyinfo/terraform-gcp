# 获取所有目标服务账号的引用（被授予权限的SA）
data "google_service_account" "target_sa" {
  for_each   = var.service_account_roles
  account_id = each.key
  project    = var.project_id
}
