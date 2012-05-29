class ganeti_tutorial::instance_image {
    $image_version  = $ganeti_tutorial::params::image_version
    $cirros_version = $ganeti_tutorial::params::cirros_version

    package {
        "dump":             ensure => installed;
        "kpartx":           ensure => installed;
    }

    file {
        "/etc/default/ganeti-instance-image":
            ensure  => present,
            require => Exec["install-instance-image"],
            content => template("ganeti_tutorial/instance-image/defaults.erb");
        "/etc/ganeti/instance-image/variants.list":
            ensure  => present,
            require => Exec["install-instance-image"],
            source  => "${ganeti_tutorial::params::files}/instance-image/variants.list";
        "/etc/ganeti/instance-image/variants/cirros.conf":
            ensure  => present,
            require => Exec["install-instance-image"],
            source  => "${ganeti_tutorial::params::files}/instance-image/cirros.conf";
        "/etc/ganeti/instance-image/variants/default.conf":
            ensure  => "/etc/ganeti/instance-image/variants/cirros.conf",
            require => [ Exec["install-instance-image"],
                         File["/etc/ganeti/instance-image/variants/cirros.conf"] ];
        "/etc/ganeti/instance-image/hooks/interfaces":
            mode    => 755,
            require => Exec["install-instance-image"];
        "/etc/ganeti/instance-image/hooks/zz_no-net":
            ensure  => present,
            mode    => 755,
            require => Exec["install-instance-image"],
            source  => "puppet:///modules/ganeti_tutorial/instance-image/hooks/zz_no-net";
    }

    ganeti_tutorial::wget {
        "cirros-root":
            require     => Exec["install-instance-image"],
            source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/cirros-${cirros_version}-${hardwaremodel}.tar.gz",
            destination => "/var/cache/ganeti-instance-image/cirros-${cirros_version}-${hardwaremodel}.tar.gz";
    }

    ganeti_tutorial::unpack {
        "instance-image":
            source      => "/root/src/ganeti-instance-image-${image_version}.tar.gz",
            cwd         => "/root/src/",
            creates     => "/root/src/ganeti-instance-image-${image_version}",
            require     => File["/root/src"];
    }

    exec {
        "install-instance-image":
            command => "/vagrant/modules/ganeti_tutorial/files/scripts/install-instance-image",
            cwd     => "/root/src/ganeti-instance-image-${image_version}",
            creates => "/srv/ganeti/os/image/",
            require => [ Ganeti_tutorial::Unpack["instance-image"], 
                Package["dump"], Package["kpartx"], File["/root/puppet"], ];
    }
}

class ganeti_tutorial::instance_image::ubuntu {
    $ubuntu_version = "${ganeti_tutorial::params::ubuntu_version}"

    file {
        "/etc/ganeti/instance-image/variants/ubuntu-11.10.conf":
            ensure  => present,
            require => Exec["install-instance-image"],
            source  => "${ganeti_tutorial::params::files}/instance-image/ubuntu-11.10.conf";
    }

    ganeti_tutorial::wget {
        "ubuntu-root":
            require     => Exec["install-instance-image"],
            source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/ubuntu-${ubuntu_version}-${hardwaremodel}.tar.gz",
            destination => "/var/cache/ganeti-instance-image/ubuntu-${ubuntu_version}-${hardwaremodel}.tar.gz";
    }
}
