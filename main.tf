# Configure the OpenStack Provider
provider "openstack" {
    user_name   = "${var.OS_USERNAME}"
    tenant_name = "${var.OS_TENANT_NAME}"
    domain_name = "${var.OS_DOMAIN_NAME}"
    password    = "${var.OS_PASSWORD}"
    auth_url    = "${var.OS_AUTH_URL}"
    insecure    = "true"
}

resource "openstack_compute_keypair_v2" "ssh-keypair" {
  name       = "chef-keypair"
  public_key = "${file("${var.SSH_KEY}.pub")}"
}
