class ganeti_tutorial::install_deps {
    package {
        # Ganeti deps
        "lvm2":             ensure=> installed;
        "bridge-utils":     ensure=> installed;
        "iproute":          ensure=> installed;
        "iputils-apring":   ensure=> installed;
        "ndisc6":           ensure=> installed;
        "python-pyopenssl": ensure=> installed;
        "openssl":          ensure=> installed;
        "python-pyparsing": ensure=> installed;
        "python-simplejson": ensure=> installed;
        "python-pyinotify": ensure=> installed;
        "python-pycurl":    ensure=> installed;
        "socat":            ensure=> installed;
        "python-paramiko":  ensure=> installed;
        # Instance Image
        "qemu-utils":       ensure=> installed;
        "dump":             ensure=> installed;
        "kpartx":           ensure=> installed;
        "kvm":              ensure=> installed;
    }
}
