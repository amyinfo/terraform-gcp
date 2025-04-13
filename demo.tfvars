project_id = "example-us-shared-vpc"
organization_id = ""
billing_account = ""

service_account_roles = {
    "bucket-manager-sa" = {
      "roles/iam.serviceAccountTokenCreator" = ["user:username@example.com", "serviceAccount:bucket-manager-sa@example-us-shared-vpc.iam.gserviceaccount.com"]
    },
    "project-service-account" = {
      "roles/iam.serviceAccountUser" = ["user:username@example.com", "serviceAccount:bucket-manager-sa@example-us-shared-vpc.iam.gserviceaccount.com"],
      "roles/iam.serviceAccountTokenCreator"         = ["user:username@example.com", "serviceAccount:bucket-manager-sa@example-us-shared-vpc.iam.gserviceaccount.com"]
    }
  }