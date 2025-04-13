# 创建防火墙规则允许 IAP SSH 访问（免费）
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = var.vpc1 # 绑定到任意 VPC

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # IAP 的 IP 范围
}

resource "google_compute_firewall" "allow_all_http" {
  name    = "allow-all-http"
  network = var.vpc1 # 绑定到任意 VPC
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-all-http"]
}

# 创建双网卡实例（免费层配置）
resource "google_compute_instance" "dual_nic_vm" {
  name         = "nat-gateway"
  machine_type = "e2-micro" # 免费实例类型
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable" # 免费 COS 镜像
      size  = 30                     # 免费存储上限（GB）
      type  = "pd-standard"
    }
  }

  can_ip_forward = true # 允许 IP 转发

  # 网卡1（VPC1 子网，无公网 IP）
  network_interface {
    subnetwork = var.subnet1
    access_config {
      network_tier = "PREMIUM"
    }
  }

  # 网卡2（VPC2 子网，无公网 IP）
  network_interface {
    subnetwork = var.subnet2
  }

  metadata = {
    enable-oslogin = "TRUE" # 启用 OS Login 简化 SSH 管理
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
    iptables -A INPUT -p tcp --dport 443 -j ACCEPT
    iptables -A FORWARD -s 10.0.2.0/24 -o eth0 -j ACCEPT
    iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o eth0 -j MASQUERADE
  EOT

  tags = ["allow-all-http"]
}
