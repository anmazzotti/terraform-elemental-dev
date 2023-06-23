terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "rancher" {
  name = "rancher"
  type = "dir"
  path = "/var/terraform-provider-libvirt-pool-rancher"
}

resource "libvirt_domain" "rancher" {
  name = "rancher"
  description = "A VM running Rancher"
  memory = 4096
  vcpu = 2
  network_interface {
    network_id     = libvirt_network.rancher.id
    hostname       = "rancher"
    addresses      = ["172.16.0.10"]
    mac            = "AA:BB:CC:11:22:22"
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.rancher_init.id

  disk {
    volume_id = libvirt_volume.rancher.id
  }
}

resource "libvirt_network" "rancher" {
  name = "rancher"
  mode = "nat"
  domain = "rancher.local"
  addresses = ["172.16.0.0/24"]
  dns {
    enabled = true
    local_only = true
  }
  dnsmasq_options {
  }
}

resource "libvirt_volume" "microos_cloud_image" {
  name   = "leap-qcow2"
  pool   = libvirt_pool.rancher.name
  source = "https://download.opensuse.org/tumbleweed/appliances/openSUSE-MicroOS.x86_64-ContainerHost-OpenStack-Cloud.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "rancher" {
  name   = "rancher"
  pool   = libvirt_pool.rancher.name
  base_volume_id = libvirt_volume.microos_cloud_image.id
}

data "template_file" "rancher_user_data" {
  template = file("${path.module}/rancher_cloud_init.cfg")
}

resource "libvirt_cloudinit_disk" "rancher_init" {
  name           = "commoninit.iso"
  user_data      = data.template_file.rancher_user_data.rendered
}
