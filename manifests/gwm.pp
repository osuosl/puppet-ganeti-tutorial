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

    ganeti_tutorial::unpack {
        "gwm":
            source  => "/root/src/ganeti-webmgr.${gwm_version}.tar.gz",
            cwd     => "/root/",
            creates => "/root/ganeti_webmgr",
            require => File["/root/src"];
    }

    file {
        "/root/ganeti_webmgr/settings.py":
            ensure  => present,
            source  => "/root/ganeti_webmgr/settings.py.dist",
            require => Ganeti_Tutorial::Unpack["gwm"];
        "/etc/init.d/vncap":
            ensure  => present,
            source  => "/root/puppet/files/gwm/vncap",
            mode    => 755;
        "/etc/init.d/flashpolicy":
            ensure  => present,
            source  => "/root/puppet/files/gwm/flashpolicy",
            mode    => 755;
    }

    exec { 
        "deploy-gwm":
            command => "/usr/local/bin/fab prod deploy",
            cwd     => "/root/ganeti_webmgr",
            timeout => "400",
            creates => "/root/ganeti_webmgr/bin/activate",
            require => [ Package["fabric"], Package["virtualenv"], 
                        Package["python-dev"], Exec["unpack-gwm"] ];
        "syncdb-gwm":
            command => "/root/puppet/files/scripts/syncdb-gwm",
            cwd     => "/root/ganeti_webmgr",
            creates => "/root/ganeti_webmgr/ganeti.db",
            require => Exec["deploy-gwm"];
    }

    service {
        "vncap":
            enable  => true,
            require => File["/etc/init.d/vncap"];
        "flashpolicy":
            enable  => true,
            require => File["/etc/init.d/flashpolicy"];
    }
}
