terraform {
  backend "gcs" {
    bucket = "amyinfo-us-shared-vpc-tf-state"
    prefix = "terraform/state"
  }
}
