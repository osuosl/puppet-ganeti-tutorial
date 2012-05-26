class ganeti_tutorial::debian {
    package {
        "qemu-utils":       ensure => installed;
    }
}

class ganeti_tutorial::debian::instance_image inherits ganeti_tutorial::instance_image {
    Exec["install-instance-image"] {
        require +> Package["qemu-utils"],
    }
}
