class ganeti_tutorial::gwm {
    package {
        "python-pip":   ensure => "installed";
        "fabric":
            ensure      => "installed",
            require     => Package["python-pip"],
            provider    => "pip";
    }

    file { "/var/lib/django": ensure => directory }

    exec { 
        "unpack_gwm":
            command => "tar -zxf /root/src/ganeti-webmgr.0.7.2.tar.gz",
            cwd     => "/var/lib/django",
            require => [ File["/root/src"], File["/var/lib/django"] ];
        "deploy-gwm":
            command => "fab prod deploy",
            cwd     => "/var/lib/django/ganeti_webmgr",
            require => [ Package["fabric"], Exec["unpack_gwm"] ];
    }
}
