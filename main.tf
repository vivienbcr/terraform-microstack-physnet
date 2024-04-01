provider "openstack" {
  auth_url      = var.os_provider.auth_url
  region        = var.os_provider.region
  endpoint_type = var.os_provider.endpoint_type
  insecure      = var.os_provider.insecure
}

resource "openstack_networking_network_v2" "management_network" {
  admin_state_up = true
  name           = "management_network"
  external       = true
  segments {
    network_type     = "flat"
    physical_network = "physnet2"
  }
}
resource "openstack_networking_subnet_v2" "management_subnet" {
  network_id = openstack_networking_network_v2.management_network.id
  cidr       = "172.16.1.0/24"
  ip_version = 4
  no_gateway = true
}
