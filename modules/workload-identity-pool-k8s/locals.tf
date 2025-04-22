# generate credential-configuration.json
locals {
  credential_config = {
    universe_domain                   = "googleapis.com"
    type                              = "external_account"
    audience                          = "//iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.waukeen.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.waukeen.workload_identity_pool_provider_id}"
    subject_token_type                = "urn:ietf:params:oauth:token-type:jwt"
    service_account_impersonation_url = "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${google_service_account.compute_viewer.email}:generateAccessToken"
    credential_source = {
      file = "/var/run/service-account/token"
      format = {
        type = "text"
      }
    }
    token_url = "https://sts.googleapis.com/v1/token"
  }
}
