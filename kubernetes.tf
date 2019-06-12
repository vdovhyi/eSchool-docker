resource "google_container_cluster" "eschoolCluster" {
  name = "${var.kubernetes_cluster_name}"
  location = "${var.zone}"
  remove_default_node_pool = true
  initial_node_count = 1
  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "eschoolContainerNodePool" {
  name = "eschool-conteiner-node-pool"
  location = "${google_container_cluster.eschoolCluster.location}"
  cluster = "${google_container_cluster.eschoolCluster.name}"
  node_count = 2
  node_config {
    preemptible = true
    machine_type = "n1-standard-2"
    metadata {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}
//resource "google_container_cluster" "eschoolCluster" {
//  name = "${var.kubernetes_cluster_name}"
//  location = "${var.zone}"
//  initial_node_count = 2
//  master_auth {
//    username = ""
//    password = ""
//  }
//  node_config {
//    oauth_scopes = [
//      "https://www.googleapis.com/auth/compute",
//      "https://www.googleapis.com/auth/devstorage.read_only",
//      "https://www.googleapis.com/auth/logging.write",
//      "https://www.googleapis.com/auth/monitoring"
//    ]
//    metadata {
//      disable-legacy-endpoints = "true"
//    }
//  }
//}