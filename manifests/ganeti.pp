class ganeti_tutorial::ganeti::install {
    ganeti_tutorial::unpack {
        "ganeti":
            source      => "/root/src/ganeti-2.4.2.tar.gz",
            cwd         => "/root/src/",
            creates     => "/root/src/ganeti-2.4.2",
            require     => File["/root/src"];
    }

    exec {
        "install-instance-image":
            command => "/root/src/ganeti-2.4.2/configure --localstatedir=/var --sysconfdir=/etc && /usr/bin/make && /usr/bin/make install",
            cwd     => "/root/src/ganeti-2.4.2",
            creates => "/usr/local/sbin/gnt-cluster",
            require => Ganeti_tutorial::Unpack["ganeti"];
    }
}
