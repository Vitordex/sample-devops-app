data "openstack_networking_network_v2" "public_network" {
  name = "PUBLIC-IPv4"
}

resource "openstack_networking_secgroup_v2" "instance_secgroup" {
  name = "${local.project_name}-secgroup-${var.environment}"
  description = "The default security group for instances in the ${local.project_name} project at ${var.environment}"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = var.ssh_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.instance_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "http_rule" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.instance_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "https_rule" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.instance_secgroup.id
}

resource "openstack_networking_network_v2" "app_network" {
  name = "${local.project_name}-network-${var.environment}"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "app_subnet" {
  name = "${local.project_name}-subnet-${var.environment}"
  network_id = openstack_networking_network_v2.app_network.id
  cidr = "192.168.0.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "app_router" {
  name = "${local.project_name}-router-${var.environment}"
  admin_state_up = true
  external_network_id = data.openstack_networking_network_v2.public_network.id
}

resource "openstack_networking_router_interface_v2" "app_router_interface" {
  router_id = openstack_networking_router_v2.app_router.id
  subnet_id = openstack_networking_subnet_v2.app_subnet.id
}

resource "openstack_networking_floatingip_v2" "instance_ip" {
  pool = data.openstack_networking_network_v2.public_network.name
}
