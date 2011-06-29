class ganeti_tutorial::gwm {
    include ganeti_tutorial::puppet

    package {
        "python-pip":   ensure => "installed";
        "fabric":
            ensure      => "installed",
            require     => [ Package["python-pip"], Package["puppet"] ],
            provider    => "pip";
    }

    file { "/var/lib/django": ensure => directory }

    exec { 
        "unpack_gwm":
            command => "/bin/tar -zxf /root/src/ganeti-webmgr.0.7.2.tar.gz",
            cwd     => "/var/lib/django",
            require => [ File["/root/src"], File["/var/lib/django"] ];
        "deploy-gwm":
            command => "/usr/local/bin/fab prod deploy",
            cwd     => "/var/lib/django/ganeti_webmgr",
            require => [ Package["fabric"], Exec["unpack_gwm"] ];
    }
}
