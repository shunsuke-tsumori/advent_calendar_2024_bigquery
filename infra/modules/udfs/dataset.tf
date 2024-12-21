data "google_project" "current" {}

resource "google_bigquery_dataset" "my_dataset" {
  dataset_id = "UDFs"
  project    = data.google_project.current.project_id
  location   = "asia-northeast1"

  description = "The dataset that contains UDFs."
}
