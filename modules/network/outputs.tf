output "vpc1" {
  value = google_compute_network.vpc1.id
}
output "vpc2" {
  value = google_compute_network.vpc2.id
}
output "subnet1" {
  value = google_compute_subnetwork.subnet1.self_link
}
output "subnet2" {
  value = google_compute_subnetwork.subnet2.self_link
}
