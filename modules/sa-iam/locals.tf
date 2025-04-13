# 获取所有成员服务账号的引用（被赋予权限的SA）
locals {
  all_member_sa_names = distinct(flatten([
    for _, roles in var.service_account_roles : [
      for _, members in roles : members
    ]
  ]))

  service_account_roles = flatten([
    for target_sa, roles in var.service_account_roles : [
      # 生成唯一键：target_sa + role
      for role, members in roles : {
        target_sa = target_sa
        role      = role
        members   = members
      }
    ]
  ])
}
