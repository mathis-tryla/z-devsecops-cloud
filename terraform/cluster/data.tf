data "google_container_cluster" "my_cluster" {
  name     = "tf-gke-cluster"
  location = "${var.region}"
}