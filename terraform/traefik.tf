resource "helm_release" "traefik" {
  name       = "traefik"
  namespace  = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"

  depends_on = [google_container_cluster.primary, google_container_node_pool.primary_preemptible_nodes, kubernetes_namespace.traefik]
}