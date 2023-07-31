variable "gke_cluster_name" {
  default = "tf-gke-cluster"
}

variable "gke_node_pool_name" {
  default = "tf-gke-node-pool"
}

variable "gke_machine_type" {
  default = "e2-standard-2"
}

variable "project_id" {
  default = "z-devsecops-cloud"
}

variable "project_name" {
  default = "Terraform k8s GKE"
}

/*variable "gcp_billing_account_name" {
  default = "Mein Rechnungskonto"
}*/

variable "region" {
  default = "europe-west9"
}

variable "zone" {
  default = "europe-west9-a"
}

variable "network_name" {
  default = "tf-gke-k8s"
}

variable "artifact_registry" {
  default = "europe-west1-docker.pkg.dev/z-devsecops-cloud/z-devsecops-registry"
}
