resource "aws_instance" "instance" {
  count                       = "${var.count}"
  ami                         = "${var.ami}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${var.security_group_id}"]
  subnet_id                   = "${var.subnet_id}"
  instance_type               = "${var.instance_type}"
  associate_public_ip_address = "true"

  root_block_device {
    volume_size = "${var.disk_size}"
  }

  tags {
    Name       = "${format("%s-%02d", var.group_name, count.index + 1)}"
    Group      = "${var.group_name}"
  }

  lifecycle {
    create_before_destroy = true
  }

  connection {
    host        = "${aws_instance.instance.public_ip}"
    user        = "${var.username}"
    private_key = "${file(var.private_key_path)}"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "#connected: to host",
    ]
  }
}

# create ansible host inventory file to be used with calling a playbook on newly created host
data "template_file" "inventory" {
  template = <<EOF
     
${aws_instance.instance.tags.Name} ansible_host=${aws_instance.instance.public_ip} ansible_user=${var.username} ansible_ssh_private_key_file=${var.private_key_path}
EOF

  depends_on = ["aws_instance.instance"]
}

resource "null_resource" "inventory" {
  triggers {
    template = "${data.template_file.inventory.rendered}"
  }

  provisioner "local-exec" {
    command = "echo \"${data.template_file.inventory.rendered}\" >> inventory"
  }
}


