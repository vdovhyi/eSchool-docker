resource "null_resource" remoteExecProvisionerWFolder {
  depends_on = ["google_sql_database_instance.instance"]
  count = 1
  connection {
    host = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }
  provisioner "file" {
     source = "${var.private_key_path}"
     destination = "/home/centos/.ssh/id_rsa"
     }
  provisioner "remote-exec" {
    inline = [ "sudo chmod 600 /home/centos/.ssh/id_rsa" ]
  }
  provisioner "remote-exec" {
    inline = [ "rm -rf /tmp/ansible" ]
  }
  provisioner "file" {
    source = "ansible"
    destination = "/tmp/ansible"
  }
  provisioner "file" {
    content = "${data.template_file.app_conf.rendered}"
    destination = "/tmp/ansible/files/application.properties"
  }
  provisioner "file" {
    content = "${data.template_file.job_frontend.rendered}"
    destination = "/tmp/ansible/files/job_frontend.xml"
  }
  provisioner "file" {
    content = "${data.template_file.job_backend.rendered}"
    destination = "/tmp/ansible/files/job_backend.xml"
  }
  provisioner "file" {
    content = "${data.template_file.deployment_frontend.rendered}"
    destination = "/tmp/ansible/kubernetes/deployment_frontend.yml"
  }
  provisioner "file" {
    content = "${data.template_file.deployment_backend.rendered}"
    destination = "/tmp/ansible/kubernetes/deployment_backend.yml"
  }
}

resource "null_resource" "ansibleProvision" {
  depends_on = ["null_resource.remoteExecProvisionerWFolder"]
  count = 1
  connection {
    host = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.private_key_path}")}"
    agent = "false"
  }
  provisioner "remote-exec" {
    inline = ["sudo sed -i -e 's+#host_key_checking+host_key_checking+g' /etc/ansible/ansible.cfg"]
  }
  provisioner "remote-exec" {
    inline = ["ansible-playbook -i /tmp/ansible/hosts.txt /tmp/ansible/main.yml"]
  }
}