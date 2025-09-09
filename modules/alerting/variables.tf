variable "notification_channels" {
  description = "Map of notification channels"
  type = map(object({
    display_name     = string
    type             = string
    labels           = map(string)
    sensitive_labels = optional(map(string))
    enabled          = optional(bool)
  }))
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
}
