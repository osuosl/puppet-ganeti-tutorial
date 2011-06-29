class ganeti_tutorial::gwm {
    include ganeti_tutorial::puppet

    package {
        "python-pip":   ensure => "installed";
        "python-dev":   ensure => "installed";
        "fabric":
            ensure      => "installed",
            require     => [ Package["python-pip"], Package["puppet"] ],
            provider    => "pip";
        "virtualenv":
            ensure      => "installed",
            require     => [ Package["python-pip"], Package["puppet"] ],
            provider    => "pip";
    }

    file { "/var/lib/django": ensure => directory }

    exec { 
        "unpack-gwm":
            command => "/bin/tar -zxf /root/src/ganeti-webmgr.0.7.2.tar.gz",
            cwd     => "/var/lib/django",
            creates => "/var/lib/django/ganeti_webmgr",
            require => [ File["/root/src"], File["/var/lib/django"] ];
        "deploy-gwm":
            command => "/usr/local/bin/fab prod deploy",
            cwd     => "/var/lib/django/ganeti_webmgr",
            creates => "/var/lib/django/ganeti_webmgr/bin/activate",
            require => [ Package["fabric"], Package["virtualenv"], 
                        Package["python-dev"], Exec["unpack-gwm"] ];
    }
}
