class ganeti_tutorial::instance_image {
    $image_files ="/etc/puppet/modules/ganeti_tutorial/files/instance-image"

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
            source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/debian-6.0.1-x86_64-boot.dump",
            destination => "/var/cache/ganeti-instance-image/debian-6.0.1-x86_64-boot.dump";
        "debian-root":
            source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/debian-6.0.1-x86_64-root.dump",
            destination => "/var/cache/ganeti-instance-image/debian-6.0.1-x86_64-root.dump";
    }
}

class ganeti_tutorial::instance_image::install inherits ganeti_tutorial::instance_image{
    ganeti_tutorial::unpack {
        "instance-image":
            source      => "/root/src/ganeti-instance-image-0.5.1.tar.gz",
            cwd         => "/root/src/",
            creates     => "/root/src/ganeti-instance-image-0.5.1",
            require     => File["/root/src"];
    }

    exec {
        "install-instance-image":
            command => "/root/src/ganeti-instance-image-0.5.1/configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc --with-os-dir=/srv/ganeti/os && /usr/bin/make && /usr/bin/make install",
            cwd     => "/root/src/ganeti-instance-image-0.5.1",
            creates => "/srv/ganeti/os/image/",
            require => Ganeti_tutorial::Unpack["instance-image"];
    }
}
