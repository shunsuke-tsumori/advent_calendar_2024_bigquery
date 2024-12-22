resource "google_data_catalog_policy_tag" "for_predefined" {
  display_name = "for_predefined"
  taxonomy     = google_data_catalog_taxonomy.taxonomy.id
  description  = "for_predefined"
}

resource "google_bigquery_datapolicy_data_policy" "predefined_policy" {
  location         = local.region
  data_policy_id   = "predefined_policy"
  policy_tag       = google_data_catalog_policy_tag.for_predefined.name
  data_policy_type = "DATA_MASKING_POLICY"
  data_masking_policy {
    predefined_expression = "SHA256"
  }
}
