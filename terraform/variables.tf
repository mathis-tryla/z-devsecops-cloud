variable "gke_machine_type" {
  default = "f1-micro"
}

variable "project_id" {
  default = "z-devsecops-cloud"
}

variable "project_name" {
  default = "Demo Terraform k8s GKE traefik"
}

/*variable "gcp_billing_account_name" {
  default = "Mein Rechnungskonto"
}*/

variable "region" {
  default = "europe-west9"
}

variable "zone" {
  default = "europe-west9-b"
}

variable "network_name" {
  default = "tf-gke-k8s"
}

variable "artifact_registry" {
  default = "europe-west1-docker.pkg.dev/z-devsecops-cloud/z-devsecops-registry"
}
