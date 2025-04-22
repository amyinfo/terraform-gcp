variable "project_id" {
  type        = string
  description = "GCP project ID"
  default     = ""
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

variable "issuer_uri" {
  description = "OIDC issuer URL"
  type        = string
  default     = "https://kubernetes.default.svc.cluster.local"
}

variable "google_subject" {
  type    = string
  default = "assertion.sub"
}

variable "attribute_namespace" {
  type    = string
  default = "assertion['kubernetes.io']['namespace']"
}

variable "attribute_serviceaccount" {
  type    = string
  default = "assertion['kubernetes.io']['serviceaccount']['name']"
}

variable "attribute_pod" {
  type    = string
  default = "assertion['kubernetes.io']['pod']['name']"
}

variable "attribute_condition" {
  type    = string
  default = "assertion['kubernetes.io']['namespace'] in ['default', 'monitoring']"
}

variable "k8s_subject" {
  type    = string
  default = "system:serviceaccount:default:gcp-workload-identity"
}

variable "k8s_namespace" {
  type    = string
  default = "default"
}
