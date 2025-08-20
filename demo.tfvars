project_id      = "example-us-shared-vpc"
organization_id = ""
billing_account = ""

service_account_roles = {
  "bucket-manager-sa" = {
    "roles/iam.serviceAccountTokenCreator" = ["user:username@example.com", "serviceAccount:bucket-manager-sa@example-us-shared-vpc.iam.gserviceaccount.com"]
  },
  "project-service-account" = {
    "roles/iam.serviceAccountUser"         = ["user:username@example.com", "serviceAccount:bucket-manager-sa@example-us-shared-vpc.iam.gserviceaccount.com"],
    "roles/iam.serviceAccountTokenCreator" = ["user:username@example.com", "serviceAccount:bucket-manager-sa@example-us-shared-vpc.iam.gserviceaccount.com"]
  }
}


notification_channels = {
  email_alert = {
    display_name = "Email Channel"
    type         = "email"
    labels = {
      email_address = "ops-team@example.com"
    }
  }

  webhook_alert = {
    display_name = "Webhook Channel"
    type         = "webhook_basicauth"
    labels = {
      url = "https://webhook.example.com/alert"
      username = "webhook_user"
    }
    sensitive_labels = {
      password = "supersecrettoken"
    }
  }
}

alert_policies = {
  high_cpu = {
    display_name = "High CPU Usage"
    combiner     = "OR"
    condition = {
      display_name       = "VM CPU > 80%"
      filter             = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""
      duration           = "300s"
      comparison         = "COMPARISON_GT"
      threshold_value    = 0.8
      alignment_period   = "60s"
      per_series_aligner = "ALIGN_MEAN"
    }

    channels_from_tf  = ["email_alert", "webhook_alert"]
    channels_existing = []
  }
}
