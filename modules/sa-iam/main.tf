# 创建 IAM 角色绑定
resource "google_service_account_iam_binding" "sa_iam" {
  for_each = tomap({
    for roles in local.service_account_roles : "${roles.target_sa}-${roles.role}" => {
      target_sa = roles.target_sa
      role      = roles.role
      members   = roles.members
    }
  })

  service_account_id = data.google_service_account.target_sa[each.value.target_sa].name
  role               = each.value.role
  members            = each.value.members
}
