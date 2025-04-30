# Firewall rules to allow IAP SSH traffic
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = var.vpc1 # Bind to any instances

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

# Firewall rules to allow all http traffic
resource "google_compute_firewall" "allow_all_http" {
  name    = "allow-all-http"
  network = var.vpc1
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-all-http"]
}

resource "google_compute_health_check" "http" {
  name = "http-health-check"
  http_health_check {
    port = 80
  }
}

resource "google_compute_instance_template" "nat_gateway_template" {
  name        = "nat-gateway-template"
  description = "Template for nat-gateway"

  machine_type = "e2-micro"
  tags         = ["allow-all-http"]

  disk {
    source_image = "cos-cloud/cos-stable"
    auto_delete  = true
    boot         = true
    disk_size_gb = 30
    disk_type    = "pd-standard"
  }

  # network interface1, public IP
  network_interface {
    subnetwork = var.subnet1
    access_config {
      network_tier = "PREMIUM"
    }
  }

  # network interface2, private IP
  network_interface {
    subnetwork = var.subnet2
  }

  can_ip_forward = true

  metadata_startup_script = <<-EOF
    #!/bin/bash
    docker run -d --rm -p 80:80 --name nginx nginx
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
    iptables -A INPUT -p tcp --dport 443 -j ACCEPT
    iptables -A FORWARD -s 10.0.2.0/24 -o eth0 -j ACCEPT
    iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o eth0 -j MASQUERADE
  EOF
}

resource "google_compute_instance_group_manager" "nat_gateway_mig" {
  name               = "nat-gateway-mig"
  base_instance_name = "nat-gateway"
  zone               = "us-central1-a"
  target_size        = 1 # instances count

  version {
    instance_template = google_compute_instance_template.nat_gateway_template.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.http.self_link
    initial_delay_sec = 300
  }
}
