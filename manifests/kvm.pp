class ganeti_tutorial::kvm {
    package {
        "kvm":
            ensure => installed,
            name    => $osfamily ? {
                debian  => "kvm",
                default => "qemu-kvm",
            };
    }

    file {
        "/boot/vmlinuz-kvmU":
            ensure  => link,
            target  => "/boot/vmlinuz-${kernelrelease}";
        "/boot/initrd-kvmU":
            ensure  => link,
            target  => $osfamily ? {
                debian  => "/boot/initrd.img-${kernelrelease}",
                redhat  => "/boot/initramfs-${kernelrelease}.img",
            }
    }

    if $osfamily == "debian" {
        service {
            "qemu-kvm":
                enable  => false,
                require => Package["kvm"],
        }
    }
}
