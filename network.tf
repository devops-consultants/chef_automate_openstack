resource "openstack_networking_network_v2" "chef" {
  name = "Chef"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "chef_subnet" {
  name       = "chef_network"
  network_id = "${openstack_networking_network_v2.chef.id}"
  cidr       = "${var.Chef_Subnet}"
  ip_version = 4
  enable_dhcp = "true"
  allocation_pools = { start = "${cidrhost(var.Chef_Subnet, 50)}"
                       end = "${cidrhost(var.Chef_Subnet, 200)}" } 
  dns_nameservers  = [ "8.8.8.8" ]
}

resource "openstack_networking_router_interface_v2" "gw_if_1" {
  region = ""
  router_id = "${var.internet_gw}"
  subnet_id = "${openstack_networking_subnet_v2.chef_subnet.id}"
}