resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend"
    namespace = "production"
  }
  spec {
    selector = {
      app  = kubernetes_deployment.frontend.spec.0.template.0.metadata[0].labels.app
      type = kubernetes_deployment.frontend.spec.0.template.0.metadata[0].labels.type
    }
    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }

  depends_on = [google_container_cluster.primary, google_container_node_pool.primary_preemptible_nodes, kubernetes_namespace.production]
}

resource "kubernetes_service" "api" {
  metadata {
    name      = "api"
    namespace = "production"
  }
  spec {
    selector = {
      app  = kubernetes_deployment.backend.spec.0.template.0.metadata[0].labels.app
      type = kubernetes_deployment.backend.spec.0.template.0.metadata[0].labels.type
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }

  depends_on = [google_container_cluster.primary, google_container_node_pool.primary_preemptible_nodes, kubernetes_namespace.production]
}

