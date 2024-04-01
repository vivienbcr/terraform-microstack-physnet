output "management_network" {
  value = openstack_networking_network_v2.management_network
}
output "management_subnet" {
  value = openstack_networking_subnet_v2.management_subnet
}
