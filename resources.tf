resource "google_project_service" "services" {
  for_each           = toset(var.services)
  service            = each.value
  disable_on_destroy = false
}

resource "google_service_account" "sa" {
  account_id = format(
    "%s-%s",
    var.service_name,
    substr(terraform.workspace, 0, 3)
  )
  create_ignore_already_exists = true
}

resource "google_project_iam_member" "roles" {
  for_each = toset([
    "roles/cloudsql.admin",
    "roles/secretmanager.secretAccessor",
    "roles/datastore.owner",
    "roles/storage.admin",
    "roles/pubsub.subscriber",
    "roles/eventarc.eventReceiver",
    "roles/logging.logWriter",
    "roles/run.admin",
    "roles/workflows.invoker",
    "roles/pubsub.publisher"
  ])
  role    = each.key
  member  = "serviceAccount:${google_service_account.sa.email}"
  project = data.google_project.project.project_id
}
