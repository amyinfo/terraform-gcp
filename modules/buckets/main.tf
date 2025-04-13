resource "google_storage_bucket" "tf_state" {
  name          = var.tf_state_bucket
  location      = "US"
  force_destroy = false

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
  uniform_bucket_level_access = true
}

# 配置 Bucket IAM 权限
resource "google_storage_bucket_iam_binding" "admins" {
  bucket = google_storage_bucket.tf_state.name
  role   = "roles/storage.admin"

  members = [
    "user:magichuihui@amyinfo.com",                            # 单个用户
    "serviceAccount:${google_service_account.bucket_sa.email}" # 服务账号
  ]
}

resource "google_storage_bucket_iam_binding" "viewers" {
  bucket = google_storage_bucket.tf_state.name
  role   = "roles/storage.objectViewer"

  members = [
    "domain:amyinfo.com" # 整个域名下的用户
  ]
}

# 创建服务账号（可选）
resource "google_service_account" "bucket_sa" {
  account_id   = "bucket-manager-sa"
  display_name = "Bucket Manager Service Account"
}
