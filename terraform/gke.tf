resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  pod_security_policy_config {
    enabled = "true"
  }

  resource_labels = {
    "env" = "staging"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.gke_node_pool_name
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "${var.gke_machine_type}"
    metadata = {
      disable-legacy-endpoints = true
    }
    workload_metadata_config {
      node_metadata = "SECURE"
    }
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    image_type = "COS"
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }
}

resource "kubernetes_namespace" "production" {
  depends_on = [google_container_cluster.primary, google_container_node_pool.primary_preemptible_nodes]

  metadata {
    labels = {
      type = "production"
    }

    name = "production"
  }
}

resource "kubernetes_namespace" "traefik" {
  depends_on = [google_container_cluster.primary, google_container_node_pool.primary_preemptible_nodes]

  metadata {
    labels = {
      type = "traefik"
    }

    name = "traefik"
  }
}