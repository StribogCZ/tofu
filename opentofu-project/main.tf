# Provider configuration (provider.tf)
terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.191.106:8006/api2/json"
#  username and password options for security
#  pm_user    = "root@pam"
#  pm_password = "YourPasswordHere"

  # insecure unless using signed certificates
  pm_tls_insecure = true
  
  # api token id is in the form of: <username>@pam!<tokenId>
  pm_api_token_id = "root@pam!tofu"

  # this is the full secret wrapped in quotes:
  pm_api_token_secret = "4f633618-2810-404c-a623-cd823664abc2"

}

resource "proxmox_vm_qemu" "test" {
    count = 5
    name = "terraform-test-vm-${count.index + 1}"
    desc = "A test for using terraform and cloudinit"
    # The VM ID for this VM
    # This has to be unique within the cluster
    # The VM ID is a number between 100 and 9999 
    # and has to be unique within the cluster
    vmid = 1000 + count.index
    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "pve"

    # The destination resource pool for the new VM
#    pool = "pool0"

    # The template name to clone this vm from
    clone = "deb12"

    # Activate QEMU agent for this VM
    agent = 1

  os_type = "cloud-init"
  cores   = 2
  sockets = 1
  vcpus   = 0
  cpu_type = "host"
  memory  = 2048
  scsihw  = "virtio-scsi-pci"

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "Drives"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 30
          cache   = "writeback"
          storage = "Drives"
          discard = true
        }
      }
    }
  }

    # Setup the network interface and assign a vlan tag: 256
    network {

        # The network interface name
        # This is the name of the interface within the VM
        id = 0
        model = "virtio"
        bridge = "vmbr0"
        #tag = 256
    }

    # Setup the ip address using cloud-init.
    boot = "order=scsi0"
    # Keep in mind to use the CIDR notation for the ip.
    #ipconfig0 = "ip=192.168.10.20/24,gw=192.168.10.1"
    ipconfig0 = "ip=dhcp"
    #sshkeys = <<EOF
    #ssh-rsa 9182739187293817293817293871== user@pc
    #EOF
    serial {
      id   = 0
      type = "socket"
    }
    
    ciuser = "debian"
    cipassword = "debian"
    cicustom = "user=code:snippets/machine-id.yaml"
}