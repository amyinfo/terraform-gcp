# ---------------------
# Notification Channels
# ---------------------
resource "google_monitoring_notification_channel" "channels" {
  for_each = var.notification_channels

  display_name = each.value.display_name
  type         = each.value.type
  labels       = each.value.labels

  dynamic "sensitive_labels" {
    for_each = lookup(each.value, "sensitive_labels", null) != null ? [each.value.sensitive_labels] : []
    content {
      auth_token  = lookup(sensitive_labels.value, "auth_token", null)
      password    = lookup(sensitive_labels.value, "password", null)
      service_key = lookup(sensitive_labels.value, "service_key", null)
    }
  }

  enabled = lookup(each.value, "enabled", true)
}

# ---------------------
# Alert Policies
# ---------------------
resource "google_monitoring_alert_policy" "alert_policies" {
  for_each = var.alert_policies

  display_name = each.value.display_name
  combiner     = each.value.combiner

  conditions {
    display_name = each.value.condition.display_name
    condition_threshold {
      filter          = each.value.condition.filter
      duration        = each.value.condition.duration
      comparison      = each.value.condition.comparison
      threshold_value = each.value.condition.threshold_value
      aggregations {
        alignment_period   = each.value.condition.alignment_period
        per_series_aligner = each.value.condition.per_series_aligner
      }
    }
  }

  # Channels
  notification_channels = concat(
    [for ch_key in lookup(each.value, "channels_from_tf", []) : google_monitoring_notification_channel.channels[ch_key].id],
    lookup(each.value, "channels_existing", [])
  )
}
