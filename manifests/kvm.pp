class ganeti_tutorial::kvm {
    package {
        "kvm":  ensure => installed;
    }

    file {
        "/boot/vmlinuz-2.6-kvmU":
            ensure  => link,
            target  => "/boot/vmlinuz-2.6.32-5-amd64";
        "/boot/initrd-2.6-kvmU":
            ensure  => link,
            target  => "/boot/initrd.img-2.6.32-5-amd64";
    }

    service {
        "qemu-kvm":
            enable  => false,
            require => Package["kvm"],
    }
}
