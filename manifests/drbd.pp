class ganeti_tutorial::drbd {
    package {
        "drbd8-utils":
            ensure  => installed,
    }

    file {
        "/etc/modules":
            ensure  => present,
            source  => "/etc/puppet/modules/ganeti_tutorial/files/modules",
    }
}
