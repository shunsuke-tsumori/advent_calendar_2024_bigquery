locals {
  project_id = "advent-calendar-2024-bigquery"
}

##########################################
# Providers
##########################################
provider "google" {
  project = local.project_id
  region  = "asia-northeast1"
}

##########################################
# Terraform
##########################################
terraform {
  required_version = ">= 1.10.3, < 2.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.14.1"
    }
  }
}

##########################################
# Projects
##########################################
resource "google_project" "this" {
  name                = local.project_id
  project_id          = local.project_id
  billing_account     = var.billing_account_id
  auto_create_network = false
  org_id              = var.org_id
}

##########################################
# Services
##########################################
locals {
  services = toset([
    "datacatalog.googleapis.com"
  ])
}

resource "google_project_service" "service" {
  for_each           = local.services
  service            = each.value
  disable_on_destroy = false
}

##########################################
# Modules
##########################################
module "udfs" {
  source = "../modules/udfs"
}
