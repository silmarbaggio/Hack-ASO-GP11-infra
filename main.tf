locals {
  gcp_project      = "hack-aso-grupo-11"
  region           = "us-central1"
  #credentials_path = "./credentials.json"
  cloud_organization = "gustavonj"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.20"
    }
  }

   cloud {
     organization = "gustavonj"

     workspaces {
       name = "hack-aso-grupo-11"
     }
   }

}

provider "google" {
  project = local.gcp_project
  region  = local.region
}

provider "google-beta" {
  project = local.gcp_project
  region  = local.region
}


resource "google_artifact_registry_repository" "play-repo" {
  location      = local.region
  project       = local.gcp_project
  repository_id = "spotmusicrepository"
  description   = "Repository Docker for Play Music Application Images"
  format        = "DOCKER"
}

resource "google_sql_database_instance" "spotmusic-db-main" {
  name             = "spotmusic-db-main"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
    disk_size = "10"
  }
}

resource "google_sql_user" "users" {
  name     = "spotuserdb"
  instance = google_sql_database_instance.spotmusic-db-main.name
  password = "hackg11"
}

resource "google_sql_database" "database" {
  name     = "spotmusicdb"
  instance = google_sql_database_instance.spotmusic-db-main.name
}
