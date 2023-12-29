output "access_private_key" {
  value = openstack_compute_keypair_v2.instance_key.private_key
  sensitive = true
}

output "access_ip" {
  value = openstack_networking_floatingip_v2.instance_ip.address
}
