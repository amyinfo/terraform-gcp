# module buckets
output "bucket_name" {
  value = module.buckets.bucket_name
}

output "bucket_url" {
  value = module.buckets.bucket_url
}

# module sa-iam
output "target_sa" {
  value = module.sa-iam.target_sa
}
output "all_member_sa_names" {
  value = module.sa-iam.all_member_sa_names
}

output "service_account_roles" {
  value = module.sa-iam.service_account_roles
}

# module network
output "vpc1" {
  value = module.network.vpc1
}
output "vpc2" {
  value = module.network.vpc2
}
output "subnet1" {
  value = module.network.subnet1
}
output "subnet2" {
  value = module.network.subnet2
}
