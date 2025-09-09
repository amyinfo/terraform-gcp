# 1. Pub/Sub Topic
resource "google_pubsub_topic" "mig_event" {
  name = "mig-event-topic"
}

# 2. Logging Sink (filter MIG events to Pub/Sub)
resource "google_logging_project_sink" "mig_event_sink" {
  name        = "mig-event-sink"
  destination = "pubsub.googleapis.com/projects/${var.project_id}/topics/${google_pubsub_topic.mig_event.name}"

  filter = <<EOT
resource.type="gce_instance_group_manager"
resource.labels.instance_group_manager_name="nat-gateway-mig"
EOT

  # grant writer identity permission
  unique_writer_identity = true
}

resource "google_pubsub_topic_iam_binding" "mig_event_sink_writer" {
  topic   = google_pubsub_topic.mig_event.name
  role    = "roles/pubsub.publisher"
  members = ["${google_logging_project_sink.mig_event_sink.writer_identity}"]

  depends_on = [google_pubsub_topic.mig_event]
}

# 3. Cloud Function (2nd gen, triggered by Pub/Sub)
resource "google_service_account" "mig_event_handler_sa" {
  account_id   = "mig-event-handler-sa"
  display_name = "Service Account for MIG Event Handler Cloud Function"
  project      = var.project_id
}

resource "google_cloudfunctions2_function" "mig_event_handler" {
  name     = "mig-event-handler"
  location = var.region

  build_config {
    runtime     = "python312"
    entry_point = "handler"
    source {
      storage_source {
        bucket = google_storage_bucket.source_bucket.name
        object = google_storage_bucket_object.source_code.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    environment_variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }

    service_account_email = google_service_account.mig_event_handler_sa.email
  }

  event_trigger {
    event_type   = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic = google_pubsub_topic.mig_event.id
    retry_policy = "RETRY_POLICY_RETRY"
  }
}

# resource "google_cloudfunctions2_function_iam_member" "invoker" {
#   cloud_function = google_cloudfunctions2_function.mig_event_handler.name
#   project        = var.project_id
#   location       = var.region

#   role   = "roles/run.invoker"
#   member = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
# }
resource "google_cloud_run_v2_service_iam_member" "member" {
  name   = google_cloudfunctions2_function.mig_event_handler.name
  role   = "roles/run.invoker"
  member = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"

}

# 4. Source bucket for function code
resource "archive_file" "default" {
  type        = "zip"
  output_path = "mig-event-handler.zip"
  source_dir  = "${path.module}/functions_src"
  excludes = [
    ".env"
  ]
}

resource "google_storage_bucket" "source_bucket" {
  name     = "${var.project_id}-functions-src"
  location = var.region

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "source_code" {
  name   = "mig-event-handler.zip"
  bucket = google_storage_bucket.source_bucket.name
  source = "mig-event-handler.zip"

  depends_on = [google_storage_bucket.source_bucket, archive_file.default]
}
