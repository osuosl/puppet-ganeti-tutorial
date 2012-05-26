class ganeti_tutorial::install_deps {
    package {
        # Ganeti deps
        "bridge-utils":     ensure => installed;
        "iproute":          ensure => installed;
        "lvm2":             ensure => installed;
        "make":             ensure => installed;
        "ndisc6":           ensure => installed;
        "openssl":          ensure => installed;
        "python-paramiko":  ensure => installed;
        "python-pycurl":    ensure => installed;
        "python-simplejson": ensure => installed;
        "socat":            ensure => installed;
        "python-pyinotify":
            ensure  => installed,
            name    => $osfamily ? {
                redhat  => "python-inotify",
                default => "python-pyinotify",
            };
        "iputils-arping":
            ensure  => installed,
            name    => $osfamily ? {
                debian  => "iputils-arping",
                default => "iputils",
            };
        "python-openssl":
            ensure  => installed,
            name    => $osfamily ? {
                redhat  => "pyOpenSSL",
                default => "python-openssl",
            };
        "python-pyparsing":
            ensure  => installed,
            name    => $osfamily ? {
                redhat  => "pyparsing",
                default => "python-pyparsing",
            };
        # Misc
        "screen":           ensure => installed;
        "git":              ensure => installed;
        "python-pip":       ensure => "installed";
        "vim":
            ensure  => installed,
            name    => $osfamily ? {
                redhat  => "vim-enhanced",
                default => "vim",
            };
    }

    file {
        "/root/src":
            ensure  => present,
            source  => "/vagrant/modules/ganeti_tutorial/files/src/",
            require => Package["make"],
            recurse => true;
    }
}
