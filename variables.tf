variable "project_id" {
  type        = string
  description = "GCP project ID"
  default     = ""
}

variable "organization_id" {
  type        = string
  description = "GCP organization ID"
  default     = ""
}

variable "billing_account" {
  type        = string
  description = "GCP billing account ID"
  default     = ""
}

variable "tf_state_bucket" {
  type        = string
  description = "GCS bucket for Terraform state"
  default     = "amyinfo-us-shared-vpc-tf-state"
}

variable "service_account_roles" {
  description = "Nested map defining IAM bindings for service accounts. Format: {target_sa = {role = [member_sa1, member_sa2]}}"
  type        = map(map(list(string)))
}
