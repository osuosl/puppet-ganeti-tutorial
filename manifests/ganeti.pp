class ganeti_tutorial::ganeti::install {
    require ganeti_tutorial::params

    $ganeti_version = "${ganeti_tutorial::params::ganeti_version}"

    ganeti_tutorial::unpack {
        "ganeti":
            source      => "/root/src/ganeti-${ganeti_version}.tar.gz",
            cwd         => "/root/src/",
            creates     => "/root/src/ganeti-${ganeti_version}",
            require     => File["/root/src"];
    }

    exec {
        "install-instance-image":
            command => "/root/src/ganeti-${ganeti_version}/configure --localstatedir=/var --sysconfdir=/etc && /usr/bin/make && /usr/bin/make install",
            cwd     => "/root/src/ganeti-${ganeti_version}",
            creates => "/usr/local/sbin/gnt-cluster",
            require => Ganeti_tutorial::Unpack["ganeti"];
    }
}
