class ganeti_tutorial::kvm {
    package {
        "kvm":  ensure => installed;
    }

    file {
        "/boot/vmlinuz-kvmU":
            ensure  => link,
            target  => "/boot/vmlinuz-${kernelrelease}";
        "/boot/initrd-kvmU":
            ensure  => link,
            target  => "/boot/initrd.img-${kernelrelease}";
    }

    service {
        "qemu-kvm":
            enable  => false,
            require => Package["kvm"],
    }
}
