/*
 * Providers
 */

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.68.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

provider "google" {
  project = "${var.project_id}"
  region  = "${var.region}"
  zone    = "${var.zone}"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

/*provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}*/