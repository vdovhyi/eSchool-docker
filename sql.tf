resource "random_integer" "ramdomIntForDBName" {
  min = 0
  max = 99999
}

resource "google_sql_database_instance" "instance" {
    name               = "${var.db_instance_name}-${random_integer.ramdomIntForDBName.result}"
    region             = "${var.region}"
    database_version   = "${var.database_version}"
    settings {
        tier             = "db-f1-micro"
        disk_autoresize  = "${var.disk_autoresize}"
        disk_size        = "${var.disk_size}"
        disk_type        = "${var.disk_type}"
        ip_configuration {
            ipv4_enabled = "true"
            authorized_networks = []
        }
    }
}

resource "google_sql_database" "default" {
  name      = "${var.db_name}"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.instance.name}"
  charset   = "${var.db_charset}"
  collation = "${var.db_collation}"
}

resource "google_sql_user" "default" {
  name     = "${var.user_name}"
  project  = "${var.project}"
  instance = "${google_sql_database_instance.instance.name}"
  host     = "${var.user_host}"
  password = "${var.user_password}"
}