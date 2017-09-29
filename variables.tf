variable "OS_TENANT_NAME" {}
variable "OS_DOMAIN_NAME" {}
variable "OS_USERNAME" {}
variable "OS_PASSWORD" {}
variable "OS_AUTH_URL" { default = "https://controller.cloud.devops-consultants.com:5000/v3" }

variable "IMAGE_NAME" { default = "CentOS 7" }
variable "IMAGE_ID"   { default =  "6c4e7dbd-8061-485e-b1c7-edc8ab3d8c99" }
variable "INSTANCE_TYPE" { default = "m1.medium" }

variable "SSH_KEY"    { default = "~/.ssh/id_rsa" }

variable "Chef_Subnet" { default = "10.0.10.0/24" }

variable "bastion_host" { default = "bastion.cloud.devops-consultants.com" }
variable "bastion_userid" {}

variable "ssh_userid" { default = "centos" }

variable "internet_gw" {}