class ganeti_tutorial::kvm {
    $kern_version = "2.6.32-5"

    package {
        "kvm":  ensure => installed;
    }

    file {
        "/boot/vmlinuz-2.6-kvmU":
            ensure  => link,
            target  => $architecture ? {
                x86_64  => "/boot/vmlinuz-${kern_version}-amd64",
                i386    => "/boot/vmlinuz-${kern_version}-686",
            };
        "/boot/initrd-2.6-kvmU":
            ensure  => link,
            target  => $architecture ? {
                x86_64  => "/boot/initrd.img-${kern_version}-amd64",
                i386    => "/boot/initrd.img-${kern_version}-686",
            };
    }

    service {
        "qemu-kvm":
            enable  => false,
            require => Package["kvm"],
    }
}
