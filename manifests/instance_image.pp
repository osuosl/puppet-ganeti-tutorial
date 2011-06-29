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
}
