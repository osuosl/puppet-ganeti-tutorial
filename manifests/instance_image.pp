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
