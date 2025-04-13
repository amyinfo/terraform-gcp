variable "service_account_roles" {
  description = "Nested map defining IAM bindings for service accounts. Format: {target_sa = {role = [member_sa1, member_sa2]}}"
  type        = map(map(list(string)))
}

variable "project_id" {
  description = "GCP project ID where service accounts exist"
  type        = string
}
