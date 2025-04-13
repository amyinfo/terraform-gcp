output "target_sa" {
  value = data.google_service_account.target_sa
}

output "all_member_sa_names" {
  value = local.all_member_sa_names
}

output "service_account_roles" {
  value = local.service_account_roles
}
