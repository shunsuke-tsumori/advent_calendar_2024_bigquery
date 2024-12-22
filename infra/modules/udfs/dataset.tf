data "google_project" "current" {}

resource "google_bigquery_dataset" "my_dataset" {
  dataset_id = "UDFs"
  project    = data.google_project.current.project_id
  location   = local.region

  description = "The dataset that contains UDFs."
}

resource "google_bigquery_table" "test_table" {
  project    = data.google_project.current.project_id
  dataset_id = google_bigquery_dataset.my_dataset.dataset_id
  table_id   = "test_ssn_masking"

  schema = <<EOF
[
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "ssn",
    "type": "STRING",
    "mode": "NULLABLE",
    "policyTags": {
      "names": [
        "${google_data_catalog_policy_tag.policy_tag.name}"
      ]
    }
  }
]
EOF
}