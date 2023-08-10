# Static IPv4 address for Ingress Load Balancing
resource "google_compute_global_address" "ingress-ipv4" {
  name       = "${var.gke_cluster_name}-ingress-ipv4"
  ip_version = "IPV4"
}

# Forward IPv4 TCP traffic to the HTTP proxy load balancer
# Google Cloud does not allow TCP proxies for port 80. Must use HTTP proxy.
resource "google_compute_global_forwarding_rule" "ingress-http-ipv4" {
  name        = "${var.gke_cluster_name}-ingress-http-ipv4"
  ip_address  = google_compute_global_address.ingress-ipv4.address
  ip_protocol = "TCP"
  port_range  = "80"
  target      = google_compute_target_http_proxy.ingress-http.self_link
  depends_on  = [google_compute_target_http_proxy.ingress-http]
}

# HTTP proxy load balancer for ingress controllers
resource "google_compute_target_http_proxy" "ingress-http" {
  name        = "${var.gke_cluster_name}-ingress-http"
  description = "Distribute HTTP load across ${var.gke_cluster_name} workers"
  url_map     = google_compute_url_map.ingress-http.self_link
  depends_on  = [google_compute_url_map.ingress-http]
}

# HTTP URL Map (required)
resource "google_compute_url_map" "ingress-http" {
  name = "${var.gke_cluster_name}-ingress-http"

  # Do not add host/path rules for applications here. Use Ingress resources.
  default_service = google_compute_backend_service.ingress-http.self_link

  depends_on = [google_compute_backend_service.ingress-http]
}

# Backend service backed by managed instance group of workers
resource "google_compute_backend_service" "ingress-http" {
  name        = "${var.gke_cluster_name}-ingress-http"
  description = "${var.gke_cluster_name} ingress service"

  protocol         = "HTTP"
  port_name        = "http"
  session_affinity = "NONE"
  timeout_sec      = "60"

  /*backend {
    group = module.workers.instance_group
  }*/

  health_checks = [google_compute_health_check.ingress.self_link]

  depends_on = [google_compute_health_check.ingress]
}

# Ingress HTTP Health Check
resource "google_compute_health_check" "ingress" {
  name        = "${var.gke_cluster_name}-ingress-health"
  description = "Health check for Ingress controller"

  timeout_sec        = 5
  check_interval_sec = 5

  healthy_threshold   = 2
  unhealthy_threshold = 4

  http_health_check {
    port         = 10254
    request_path = "/healthz"
  }
}