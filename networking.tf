#1. Create a new VPC
resource "google_compute_network" "main" {
  name                    = "vpc-kong"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
  project                 = var.project_id
}
#2. Create a new NAT router so the nodes or VMs can reach the public Internet
resource "google_compute_router" "router-tw" {
  name    = "rt-kong"
  project = var.project_id
  region  = var.region
  network = google_compute_network.main.name

  bgp {
    asn = 64514
  }
 depends_on = [google_compute_network.main]
}

#3. Add subnetworks to the Cloud NAT

resource "google_compute_router_nat" "router_nat-tw" {
  name                               = "nat-kong"
  router                             = google_compute_router.router-tw.name
  region                             = google_compute_router.router-tw.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}


#4. Create subnet

resource "google_compute_subnetwork" "subnet-kong" {
  name          = "subnet-kong"
  ip_cidr_range = "10.255.0.0/24"
  private_ip_google_access = true
  region        = var.region
  network       = google_compute_network.main.self_link
    secondary_ip_range = [ # If we don't use alias IP. We can remove the secondary_ip_range by commenting out the block
    {
      range_name = "gke-pods"

      ip_cidr_range = "172.18.0.0/20"
    },
    {
      range_name = "gke-services"

      ip_cidr_range = "192.168.0.0/22"
    },
  ]

}



