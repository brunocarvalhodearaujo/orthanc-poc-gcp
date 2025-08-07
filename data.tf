data "google_project" "project" {}

data "google_iam_policy" "orthanc" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}
