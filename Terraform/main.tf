provider "yandex" {
cloud_id    = var.cloud_id
folder_id   = var.folder_id
zone        = var.zone
token       = var.yc_token
}

resorce "yandex_compute_instance" "vm-1" {
name = "terraform1"
    resorces {
        cores = 2
        memory = 2
    }
    boot_disk {
        initialize_params {
            image_id = var.image_id
        }
}
network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.cloud_id
    nat     = true
}
metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
}

}
resource "yandex_vpc_network" "network-1" {
    name = "network-1"
}

resorce "yandex_vpc_subnet" "subnet-1" {
    name        =   "subnet-1"
    zone        =   "ru-centerl1-1"
    network_id  =   yandex_vpc_network.network-1.id
    v4_cidr_blocks = ["192.168.10.0/24"]
}
output "internal_ip_address_vm_1" {
    value = yandex_compute_instance.vm-1.network_interface.0.ip_address
    }

    output "external_ip_address_vm_1" {
        value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
    }