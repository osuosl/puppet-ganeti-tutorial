class ganeti_tutorial::instance_image {
    require ganeti_tutorial::params

    $image_version  = "${ganeti_tutorial::params::image_version}"
    $debian_version = "${ganeti_tutorial::params::debian_version}"

    package {
        "qemu-utils":       ensure => installed;
        "dump":             ensure => installed;
        "kpartx":           ensure => installed;
    }

    file {
        "/etc/default/ganeti-instance-image":
            ensure  => present,
            require => Exec["install-instance-image"],
            source  => "${ganeti_tutorial::params::files}/instance-image/defaults";
        "/etc/ganeti/instance-image/variants.list":
            ensure  => present,
            require => Exec["install-instance-image"],
            source  => "${ganeti_tutorial::params::files}/instance-image/variants.list";
        "/etc/ganeti/instance-image/variants/debian-lenny.conf":
            ensure  => present,
            require => Exec["install-instance-image"],
            source  => "${ganeti_tutorial::params::files}/instance-image/debian-lenny.conf";
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
        "debian-boot":
            require     => Exec["install-instance-image"],
            source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/debian-${debian_version}-x86_64-boot.dump",
            destination => "/var/cache/ganeti-instance-image/debian-${debian_version}-x86_64-boot.dump";
        "debian-root":
            require     => Exec["install-instance-image"],
            source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/debian-${debian_version}-x86_64-root.dump",
            destination => "/var/cache/ganeti-instance-image/debian-${debian_version}-x86_64-root.dump";
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
            command => "/root/puppet/files/intance-image/install-instance-image",
            cwd     => "/root/src/ganeti-instance-image-${image_version}",
            creates => "/srv/ganeti/os/image/",
            require => [ Ganeti_tutorial::Unpack["instance-image"], 
                Package["dump"], Package["kpartx"], Package["qemu-utils"],
                File["/root/puppet"], ];
    }
}
