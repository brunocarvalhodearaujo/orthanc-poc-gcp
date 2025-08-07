variable "project_name" {
  description = "project name to deploy the service"
  type        = string
  default     = "orthanc-poc"
}

variable "region" {
  description = "region to deploy the service"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "service name to deploy"
  type        = string
}

variable "service_image" {
  description = "service image to deploy"
  type        = string
  default     = "orthancteam/orthanc-pre-release:wado-rs-threads"
}

variable "google_credentials" {
  description = "google credentials for service account"
  type        = string
}

variable "services" {
  description = "services to enable for the project"
  type        = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "pubsub.googleapis.com",
    "iam.googleapis.com",
    "cloudscheduler.googleapis.com",
    "eventarc.googleapis.com",
    "workflows.googleapis.com"
  ]
}

variable "postgresql_database" {
  type      = string
}

variable "postgresql_username" {
  type      = string
}

variable "postgresql_password" {
  type      = string
  sensitive = true
}

variable "postgresql_host" {
  type      = string
}

variable "postgresql_port" {
  type    = number
  default = 5432
}

variable "postgresql_enable_ssl" {
  type    = bool
  default = false
}

variable "google_cloud_storage_bucket_name" {
  type    = string
}