# Outputs for Kubernetes Ingress

output "ingress_static_ipv4" {
  description = "Global IPv4 address for proxy load balancing to the nearest Ingress controller"
  value       = google_compute_global_address.ingress-ipv4.address
}