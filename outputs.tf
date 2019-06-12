output "jenkins_public_ip" {
   value = ["${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"]
}

output "public_ip_sql" {
   value = ["${google_sql_database_instance.instance.ip_address.0.ip_address}"]
}

output "public_static_ip" {
   value = ["${google_compute_address.address.*.address}"]
}
