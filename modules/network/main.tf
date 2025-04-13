# 创建 VPC-1 和子网
resource "google_compute_network" "vpc1" {
  name                    = "vpc1"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc1.id
}

# 创建 VPC-2 和子网
resource "google_compute_network" "vpc2" {
  name                    = "vpc2"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc2.id
}

# 创建 VPC 对等连接（免费）
resource "google_compute_network_peering" "vpc1_to_vpc2" {
  name         = "peer-vpc1-to-vpc2"
  network      = google_compute_network.vpc1.self_link
  peer_network = google_compute_network.vpc2.self_link
}

resource "google_compute_network_peering" "vpc2_to_vpc1" {
  name         = "peer-vpc2-to-vpc1"
  network      = google_compute_network.vpc2.self_link
  peer_network = google_compute_network.vpc1.self_link
}
