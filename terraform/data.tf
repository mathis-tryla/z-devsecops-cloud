# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

/*data "google_container_cluster" "my_cluster" {
  name     = "${var.gke_cluster_name}"
  location = "${var.zone}"
}*/