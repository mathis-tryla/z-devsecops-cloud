resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = "production"
    labels = {
      app = "devsecops"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app  = "devsecops"
        type = "api"
      }
    }
    template {
      metadata {
        labels = {
          app  = "devsecops"
          type = "api"
        }
      }
      spec {
        container {
          name              = "backend"
          image             = "${var.artifact_registry}/backend:latest"
          image_pull_policy = "Always"

          port {
            name           = "http"
            container_port = 8080
          }
        }
      }
    }
  }

  depends_on = [google_container_cluster.primary, google_container_node_pool.primary_preemptible_nodes, kubernetes_namespace.production]
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = "production"
    labels = {
      app = "devsecops"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app  = "devsecops"
        type = "front"
      }
    }
    template {
      metadata {
        labels = {
          app  = "devsecops"
          type = "front"
        }
      }
      spec {
        container {
          name              = "frontend"
          image             = "${var.artifact_registry}/frontend:latest"
          image_pull_policy = "Always"
          env {
            name  = "BASE_URL"
            value = "https://api:8080"
          }

          port {
            name           = "main"
            container_port = 3000
          }
        }
      }
    }
  }

  depends_on = [google_container_cluster.primary, google_container_node_pool.primary_preemptible_nodes, kubernetes_namespace.production]
}
