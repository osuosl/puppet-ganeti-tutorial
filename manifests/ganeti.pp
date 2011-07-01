class ganeti_tutorial::ganeti::install {
    require ganeti_tutorial::params

    $ganeti_version = "${ganeti_tutorial::params::ganeti_version}"

    file {
        "/etc/init.d/ganeti":
            ensure  => present,
            require => Ganeti_tutorial::Unpack["ganeti"],
            source  => "/root/src/ganeti-${ganeti_version}/doc/examples/ganeti.initd",
            mode    => 755,
    }

    ganeti_tutorial::unpack {
        "ganeti":
            source      => "/root/src/ganeti-${ganeti_version}.tar.gz",
            cwd         => "/root/src/",
            creates     => "/root/src/ganeti-${ganeti_version}",
            require     => File["/root/src"];
    }

    exec {
        "install-ganeti":
            command => "/root/src/ganeti-${ganeti_version}/configure --localstatedir=/var --sysconfdir=/etc && /usr/bin/make && /usr/bin/make install",
            cwd     => "/root/src/ganeti-${ganeti_version}",
            creates => "/usr/local/sbin/gnt-cluster",
            require => Ganeti_tutorial::Unpack["ganeti"];
    }

    service {
        "ganeti":
            enable      => true,
            require     => File["/etc/init.d/ganeti"],
    }
}
