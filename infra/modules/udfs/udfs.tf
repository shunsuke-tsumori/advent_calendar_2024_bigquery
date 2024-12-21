resource "google_bigquery_routine" "custom_masking" {
  dataset_id = google_bigquery_dataset.my_dataset.dataset_id
  routine_id = "custom_masking_fn"

  routine_type         = "SCALAR_FUNCTION"
  language             = "SQL"
  data_governance_type = "DATA_MASKING"

  arguments {
    name = "ssn"
    data_type = jsonencode({ "typeKind" : "STRING" })
  }

  return_type = jsonencode({ "typeKind" : "STRING" })

  definition_body = "SAFE.REGEXP_REPLACE(ssn, '[0-9]', 'X')"
}

resource "google_data_catalog_taxonomy" "taxonomy" {
  region       = local.region
  display_name = "the_taxonomy"
  description  = "the_taxonomy"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
}

resource "google_data_catalog_policy_tag" "policy_tag" {
  taxonomy     = google_data_catalog_taxonomy.taxonomy.id
  display_name = "the_tag"
  description  = "the_tag"
}

resource "google_bigquery_datapolicy_data_policy" "data_policy" {
  location         = local.region
  data_policy_id   = "data_policy"
  policy_tag       = google_data_catalog_policy_tag.policy_tag.name
  data_policy_type = "DATA_MASKING_POLICY"
  data_masking_policy {
    routine = google_bigquery_routine.custom_masking.id
  }
}
