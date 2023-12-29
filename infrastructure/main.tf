provider "openstack" {
  auth_url = "https://identity.wse.zone/v3/"
  tenant_name = "sre.binario.cloud"
  application_credential_id = var.application_credential_id
  application_credential_secret = var.application_credential_secret
  project_domain_id = "default"
}

locals {
  project_name = "sample-devops-app"
}

data "openstack_compute_flavor_v2" "bc_8_8" {
  name = "bc1-standard-4-8"
}

data "openstack_images_image_v2" "ubuntu" {
  name = "BC-Ubuntu-22.04"
  most_recent = true
}

resource "openstack_compute_keypair_v2" "instance_key" {
  name = "${local.project_name}-keypair-${var.environment}"
}

resource "openstack_compute_instance_v2" "deploy_instance" {
  name = "${local.project_name}-instance-${var.environment}"

  key_pair = openstack_compute_keypair_v2.instance_key.name

  flavor_id = data.openstack_compute_flavor_v2.bc_8_8.id

  block_device {
    uuid = data.openstack_images_image_v2.ubuntu.id
    source_type = "image"
    boot_index = 0
    volume_size = 20
    destination_type = "volume"
    delete_on_termination = true
  }

  security_groups = ["default", openstack_networking_secgroup_v2.instance_secgroup.name]
  network {
    name = openstack_networking_network_v2.app_network.name
  }
}

resource "openstack_compute_floatingip_associate_v2" "ip_instance_association" {
  floating_ip = openstack_networking_floatingip_v2.instance_ip.address
  instance_id = openstack_compute_instance_v2.deploy_instance.id
}
