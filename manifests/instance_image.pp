class ganeti_tutorial::instance_image {
    require ganeti_tutorial::params

    $image_files    = "/etc/puppet/modules/ganeti_tutorial/files/instance-image"
    $image_version  = ${ganeti_tutorial::params::image_version}
    $debian_version = ${ganeti_tutorial::params::debian_version}

    file {
        "/etc/default/ganeti-instance-image":
            ensure  => present,
            source  => "${image_files}/defaults";
        "/etc/ganeti/instance-image/variants.list":
            ensure  => present,
            source  => "${image_files}/variants.list";
        "/etc/ganeti/instance-image/variants/debian-lenny.conf":
            ensure  => present,
            source  => "${image_files}/debian-lenny.conf";
        "/etc/ganeti/instance-image/hooks/interfaces":
            mode    => 755;
    }

    ganeti_tutorial::wget {
        "debian-boot":
            source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/debian-${debian_version}-x86_64-boot.dump",
            destination => "/var/cache/ganeti-instance-image/debian-${debian_version}-x86_64-boot.dump";
        "debian-root":
            source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/debian-${debian_version}-x86_64-root.dump",
            destination => "/var/cache/ganeti-instance-image/debian-${debian_version}-x86_64-root.dump";
    }
}

class ganeti_tutorial::instance_image::install inherits ganeti_tutorial::instance_image{
    ganeti_tutorial::unpack {
        "instance-image":
            source      => "/root/src/ganeti-instance-image-${image_version}.tar.gz",
            cwd         => "/root/src/",
            creates     => "/root/src/ganeti-instance-image-${image_version}",
            require     => File["/root/src"];
    }

    exec {
        "install-instance-image":
            command => "/root/src/ganeti-instance-image-${image_version}/configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-os-dir=/srv/ganeti/os && /usr/bin/make && /usr/bin/make install",
            cwd     => "/root/src/ganeti-instance-image-${image_version}",
            creates => "/srv/ganeti/os/image/",
            require => Ganeti_tutorial::Unpack["instance-image"];
    }
}
