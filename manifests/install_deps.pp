class ganeti_tutorial::install_deps {
    package {
        # Ganeti deps
        "lvm2":             ensure => installed;
        "bridge-utils":     ensure => installed;
        "iproute":          ensure => installed;
        "iputils-arping":   ensure => installed;
        "ndisc6":           ensure => installed;
        "python-openssl":   ensure => installed;
        "openssl":          ensure => installed;
        "python-pyparsing": ensure => installed;
        "python-simplejson": ensure => installed;
        "python-pyinotify": ensure => installed;
        "python-pycurl":    ensure => installed;
        "socat":            ensure => installed;
        "python-paramiko":  ensure => installed;
        # Instance Image
        "qemu-utils":       ensure => installed;
        "dump":             ensure => installed;
        "kpartx":           ensure => installed;
        # Misc
        "vim":              ensure => installed;
        "screen":           ensure => installed;
        "git":              ensure => installed;
    }

    file {
        "/root/src":
            ensure  => present,
            source  => "/etc/puppet/modules/ganeti_tutorial/files/src/",
            recurse => true;
    }
}
