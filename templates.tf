data "template_file" "app_conf" {
  template = "${file("${path.module}/templates/application.properties.tpl")}"
  depends_on = ["google_sql_database_instance.instance"]
  vars {
    db_server = "localhost"
    db_name = "${var.db_name}"
    db_user = "${var.user_name}"
    db_pass = "${var.user_password}"
  }
}

data "template_file" "job_frontend" {
  template = "${file("${path.module}/templates/job_frontend.tpl")}"
  vars {
    backend_ip = "${google_compute_address.address.address}"
    google_json_key_name = "${var.google_json_key_name}"
    project_id = "${var.project}"
    kubernetes_cluster_name = "${var.kubernetes_cluster_name}"
    region = "${var.region}"
    zone = "${var.zone}"
  }
}

data "template_file" "job_backend" {
  template = "${file("${path.module}/templates/job_backend.tpl")}"
  vars {
    google_json_key_name = "${var.google_json_key_name}"
    project_id = "${var.project}"
    kubernetes_cluster_name = "${var.kubernetes_cluster_name}"
    region = "${var.region}"
    zone = "${var.zone}"
    db_user = "${var.user_name}"
    db_pass = "${var.user_password}"
  }
}

data "template_file" "deployment_frontend" {
  template = "${file("${path.module}/templates/deployment-frontend.tpl")}"
  vars {
    project_id = "${var.project}"
    backend_ip = "${google_compute_address.address.address}"
  }
}

data "template_file" "deployment_backend" {
  depends_on = ["google_sql_database_instance.instance"]
  template = "${file("${path.module}/templates/deployment-backend.tpl")}"
  vars {
    project_id = "${var.project}"
    backend_ip = "${google_compute_address.address.address}"
    region = "${var.region}"
    db_instance_name = "${google_sql_database_instance.instance.name}"
  }
}