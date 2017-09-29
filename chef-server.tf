resource "openstack_blockstorage_volume_v1" "chefserver_system" {
  name = "chefserver_system"
  size = 20
  image_id = "${var.IMAGE_ID}"
  description = "System volume for Chef Server"
}

data "openstack_images_image_v2" "centos" {
  name = "${var.IMAGE_NAME}"
  most_recent = true
}

resource "openstack_compute_instance_v2" "chef_server" {
  name        = "chefserver"
  flavor_name = "${var.INSTANCE_TYPE}"
  key_pair    = "${openstack_compute_keypair_v2.ssh-keypair.name}"
  security_groups = ["${openstack_networking_secgroup_v2.any_ssh.name}",
                     "${openstack_networking_secgroup_v2.chef_automate.name}"]

  network {
    name = "${openstack_networking_network_v2.chef.name}"
  }

  block_device {
    uuid = "${openstack_blockstorage_volume_v1.chefserver_system.id}"
    source_type = "volume"
    boot_index = 0
    volume_size = "${openstack_blockstorage_volume_v1.chefserver_system.size}"
    destination_type = "volume"
    delete_on_termination = true
  }
}

resource "null_resource" "chefserver" {
#     name          = "${var.hostname}"
#     catalog_name  = "${var.catalog}"
#     template_name = "${var.vapp_template}"
#     memory        = "${var.memory}"
#     cpus          = "${var.cpu_count}"
#     network_name  = "${var.network_name}"
#     ip            = "${var.int_ip}"

#     initscript    = "mkdir -p ${var.ssh_user_home}/.ssh; echo \"${var.ssh_key_pub}\" >> ${var.ssh_user_home}/.ssh/authorized_keys; chmod -R go-rwx ${var.ssh_user_home}/.ssh; restorecon -Rv ${var.ssh_user_home}/.ssh"

    connection {
        host = "${openstack_compute_instance_v2.chef_server.access_ip_v4}"
        user = "${var.ssh_userid}"
        private_key = "${file("${var.SSH_KEY}")}"

        bastion_host = "${var.bastion_host}"
        bastion_user = "${var.bastion_userid}"
        bastion_private_key = "${file("${var.SSH_KEY}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum -y update"
#         "yum -y install wget",
#         "cd /tmp",
#         "wget ${var.chef_download}",
#         "rpm -Uvh /tmp/chef-server-core*",
#         "chef-server-ctl reconfigure",
#         "mkdir -p ${var.ssh_user_home}/.chef",
#         "echo '${template_file.knife.rendered}' > ${var.ssh_user_home}/.chef/knife.rb",
#         "chef-server-ctl user-create ${var.chef_admin_userid} ${var.chef_admin_firstname} ${var.chef_admin_lastname} ${var.chef_admin_email} '${var.chef_admin_password}' --filename ${var.ssh_user_home}/.chef/${var.chef_admin_userid}.pem",
#         "chef-server-ctl org-create ${var.chef_org_short} '${var.chef_org_full}' --association_user ${var.chef_admin_userid} --filename ${var.ssh_user_home}/.chef/${var.chef_org_short}-validator.pem",
#         "chef-server-ctl install chef-manage",
#         "chef-server-ctl reconfigure",
#         "chef-manage-ctl reconfigure",
#         "chef-server-ctl install opscode-reporting",
#         "chef-server-ctl reconfigure",
#         "opscode-reporting-ctl reconfigure",
#         "cd ${var.ssh_user_home}",
#         "tar zcvf ${var.ssh_user_home}/chefconfig.tar.gz .chef/*"
        ]
    }
}