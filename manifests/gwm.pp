class ganeti_tutorial::gwm {
    include ganeti_tutorial::puppet
    require ganeti_tutorial::params

    $gwm_version = "${ganeti_tutorial::params::gwm_version}"

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

    ganeti_tutorial::unpack {
        "gwm":
            source  => "/root/src/ganeti-webmgr.${gwm_version}.tar.gz",
            cwd     => "/var/lib/django",
            creates => "/var/lib/django/ganeti_webmgr",
            require => [ File["/root/src"], File["/var/lib/django"] ];
    }

    exec { 
        "deploy-gwm":
            command => "/usr/local/bin/fab prod deploy",
            cwd     => "/var/lib/django/ganeti_webmgr",
            timeout => "120",
            creates => "/var/lib/django/ganeti_webmgr/bin/activate",
            require => [ Package["fabric"], Package["virtualenv"], 
                        Package["python-dev"], Exec["unpack-gwm"] ];
    }
}
