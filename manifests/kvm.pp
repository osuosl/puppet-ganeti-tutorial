class ganeti_tutorial::kvm {
    $kern_version = $operatingsystem ? {
        Debian => $lsbmajdistrelease ? {
            6 => "2.6.32-5",
        }
        Ubuntu => $lsbdistrelease ? {
            11.10   => "3.0.0-13",
        }
    }

    package {
        "kvm":  ensure => installed;
    }

    file {
        "/boot/vmlinuz-kvmU":
            ensure  => link,
            target  => $hardwaremodel ? {
                x86_64  => "/boot/vmlinuz-${kern_version}-amd64",
                i686    => "/boot/vmlinuz-${kern_version}-686",
            };
        "/boot/initrd-kvmU":
            ensure  => link,
            target  => $hardwaremodel ? {
                x86_64  => "/boot/initrd.img-${kern_version}-amd64",
                i686    => "/boot/initrd.img-${kern_version}-686",
            };
    }

    service {
        "qemu-kvm":
            enable  => false,
            require => Package["kvm"],
    }
}
