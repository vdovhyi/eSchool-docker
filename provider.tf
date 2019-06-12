provider "google" {
  credentials = ".ssh/${var.google_json_key_name}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}
