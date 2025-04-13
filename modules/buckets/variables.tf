variable "tf_state_bucket" {
  type        = string
  description = "GCS bucket for Terraform state"
  default     = "amyinfo-us-shared-vpc-tf-state"
}

