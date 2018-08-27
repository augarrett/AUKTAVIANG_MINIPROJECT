locals {
  public_ip =   "${element(module.ubuntu16.public_ip, 0)}"
  instance_id = "${element(module.ubuntu16.instance_id, 0)}"
  priv_key_loc = "${var.private_key_path}"
}

output "ami" {
  value = "${data.aws_ami.ubuntu16.image_id}"
}

output "public_ip" {
  value = "${local.public_ip}"
}


output "instance_id" {
  value = "${local.instance_id}"
}

output "priv_key_loc" {
  value = "${local.priv_key_loc}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc_main.id}"
}

output "key_pair_id" {
  value = "${aws_key_pair.auth.id}"
}

output "rt_table" {
  value = "${aws_vpc.vpc_main.main_route_table_id}"
}

output "subnet_id" {
  value = "${aws_subnet.public.id}"
}