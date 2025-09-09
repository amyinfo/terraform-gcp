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

variable "pool_id" {
  description = "Workload identity pool ID"
  type        = string
  default     = "docker-desktop"
}

variable "provider_id" {
  description = "OIDC provider ID"
  type        = string
  default     = "docker-desktop"
}

variable "notification_channels" {
  description = "Map of notification channels"
  type = map(object({
    display_name     = string
    type             = string
    labels           = map(string)
    sensitive_labels = optional(map(string))
    enabled          = optional(bool)
  }))

  default = {}
}

variable "alert_policies" {
  description = "Map of alert policies"
  type = map(object({
    display_name = string
    combiner     = string
    condition = object({
      display_name       = string
      filter             = string
      duration           = string
      comparison         = string
      threshold_value    = number
      alignment_period   = string
      per_series_aligner = string
    })
    channels_from_tf  = optional(list(string)) # terraform managed channels
    channels_existing = optional(list(string)) # existing channel ID
  }))

  default = {}
}

variable "region" {
  description = "Default GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Default GCP zone"
  type        = string
  default     = "us-central1-c"
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for notifications"
  type        = string
  sensitive   = true
}
