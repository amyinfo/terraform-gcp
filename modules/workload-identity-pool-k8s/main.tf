# Create Workload Identity Pool
resource "google_iam_workload_identity_pool" "waukeen" {
  workload_identity_pool_id = var.pool_id
  display_name              = "waukeen"
  description               = "Access from kubernetes on waukeen"
}

# Create OIDC Provider for kubernetes
resource "google_iam_workload_identity_pool_provider" "waukeen" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.waukeen.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = "Kubernetes OIDC Provider"

  # OIDC endpoint
  oidc {
    issuer_uri = var.issuer_uri
    jwks_json  = file("${path.module}/cluster-jwks.json")
  }

  attribute_condition = var.attribute_condition

  # attribute map
  attribute_mapping = {
    "google.subject"                 = var.google_subject
    "attribute.namespace"            = var.attribute_namespace
    "attribute.service_account_name" = var.attribute_serviceaccount
    "attribute.pod"                  = var.attribute_pod
  }

}

# Create GCP Service Account with compute.viewer role
resource "google_service_account" "compute_viewer" {
  account_id   = "compute-viewer"
  display_name = "Compute Viewer Service Account"
  project      = var.project_id
}

# Bind compute.viewer to the compute_viewer service account
resource "google_project_iam_member" "compute_viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.compute_viewer.email}"
}

# resource "google_project_iam_member" "compute_viewer_workload_identity" {
#   project = var.project_id
#   role    = "roles/compute.viewer"
#   member  = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.waukeen.name}/subject/${var.k8s_subject}"
# }

# grant the workload identity user to the k8s service account
resource "google_service_account_iam_member" "workload_identity_pool" {
  service_account_id = google_service_account.compute_viewer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.waukeen.name}/subject/${var.k8s_subject}"
}

resource "google_service_account_iam_member" "workload_identity_user_for_namespace" {
  service_account_id = google_service_account.compute_viewer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.waukeen.name}/attribute.namespace/${var.k8s_namespace}"
}

# Create credential-configuration.json file
resource "local_file" "credential_config" {
  filename = "${path.root}/credential-configuration.json"
  content  = jsonencode(local.credential_config)
}
