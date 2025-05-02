terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9"
    }
  }

  required_version = ">= 0.12"
}

provider "proxmox" {
  pm_api_url      = "https://192.168.88.106:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = "${var.pve_pass}"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "cloned_vm" {
  name       = "cloned-vm"
  target_node = "proxmox-node"
  clone      = "101"

  disk {
    size     = "10G"
    type     = "scsi"
    storage  = "Drives"
    iothread = 0
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  cores   = 2
  memory  = 2048
  sockets = 1
}

output "vm_id" {
  value = proxmox_vm_qemu.cloned_vm.id
}