class ganeti_tutorial::instance_image {
    require ganeti_tutorial::params

    $image_version  = "${ganeti_tutorial::params::image_version}"
    $debian_version = "${ganeti_tutorial::params::debian_version}"
    $cirros_version = "${ganeti_tutorial::params::cirros_version}"

    package {
        #"qemu-utils":       ensure => installed;
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
        "/etc/ganeti/instance-image/variants/debian-lenny.conf":
            ensure  => present,
            require => Exec["install-instance-image"],
            source  => "${ganeti_tutorial::params::files}/instance-image/debian-lenny.conf";
        "/etc/ganeti/instance-image/variants/cirros.conf":
            ensure  => present,
            require => Exec["install-instance-image"],
            source  => "${ganeti_tutorial::params::files}/instance-image/cirros.conf";
        "/etc/ganeti/instance-image/hooks/interfaces":
            mode    => 755,
            require => Exec["install-instance-image"];
        "/etc/ganeti/instance-image/hooks/zz_no-net":
            ensure  => present,
            mode    => 755,
            require => Exec["install-instance-image"],
            source  => "${ganeti_tutorial::params::files}/instance-image/hooks/zz_no-net";
    }

    ganeti_tutorial::wget {
        "debian-root":
            require     => Exec["install-instance-image"],
            source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/debian-${debian_version}-${hardwaremodel}.tar.gz",
            destination => "/var/cache/ganeti-instance-image/debian-${debian_version}-${hardwaremodel}.tar.gz";
        "cirros-root":
            require     => Exec["install-instance-image"],
            source      => "http://launchpad.net/cirros/trunk/${cirros_version}/+download/cirros-${cirros_version}-${hardwaremodel}-lxc.tar.gz",
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
