terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.73.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_firewall" "firewall-ingress" {
  name    = "terraform-firewall-ingress"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "firewall-egress" {
  name      = "terraform-firewall-egress"
  network   = google_compute_network.vpc_network.name
  direction = "EGRESS"

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_instance" "vm_instance" {
  count        = var.instance_count
  name         = "terraform-instance${count.index}"
  machine_type = "e2-micro"
  tags         = ["web", "dev"]
  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key)}"
  }

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20210623"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}