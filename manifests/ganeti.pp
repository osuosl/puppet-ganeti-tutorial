class ganeti_tutorial::ganeti::install {
    require ganeti_tutorial::params

    $ganeti_version = "${ganeti_tutorial::params::ganeti_version}"

    file {
        "/etc/init.d/ganeti":
            ensure  => present,
            require => Exec["install-ganeti"],
            source  => "/root/src/ganeti-${ganeti_version}/doc/examples/ganeti.initd",
            mode    => 755,
    }

    ganeti_tutorial::unpack {
        "ganeti":
            source      => "/root/src/ganeti-${ganeti_version}.tar.gz",
            cwd         => "/root/src/",
            creates     => "/root/src/ganeti-${ganeti_version}",
            require     => File["/root/src"];
    }

    exec {
        "install-ganeti":
            command => "/root/src/ganeti-${ganeti_version}/configure --localstatedir=/var --sysconfdir=/etc && /usr/bin/make && /usr/bin/make install",
            cwd     => "/root/src/ganeti-${ganeti_version}",
            creates => "/usr/local/sbin/gnt-cluster",
            require => Ganeti_tutorial::Unpack["ganeti"];
    }

    service {
        "ganeti":
            enable      => true,
            require     => File["/etc/init.d/ganeti"],
    }
}

class ganeti_tutorial::ganeti::initialize inherits ganeti_tutorial::ganeti::install {
    exec {
        "initialize-ganeti":
            command => "/usr/local/sbin/gnt-cluster init --vg-name=ganeti -s 192.168.16.16 --master-netdev=br0 -H kvm:kernel_path=/boot/vmlinuz-2.6=kvmU,initrd_path=/boot/initrd-img-2.6-kvmU,nic_type=e1000,disk_type=scsi,vnc_bind_address=0.0.0.0,serial_console=true --enabled-hypervisors=kvm ganeti.example.org",
            creates => "/var/lib/ganeti/config.data",
            require => Exec["install-ganeti"],
    }
}
