# Ganeti Tutorial

class ganeti_tutorial {
    require ganeti_tutorial::params

    include ganeti_tutorial::install_deps
    include ganeti_tutorial::hosts
    include ganeti_tutorial::networking
    include ganeti_tutorial::drbd

    file {
        "/root/.ssh":
            ensure  => directory;
        "/boot/vmlinuz-2.6-kvmU":
            ensure  => link,
            target  => "/boot/vmlinuz-2.6.32-5-amd64";
        "/boot/initrd-2.6-kvmU":
            ensure  => link,
            target  => "/boot/initrd.img-2.6.32-5-amd64";
        "/root/puppet":
            ensure  => link,
            target  => "/etc/puppet/modules/manifests/ganeti_tutorial";
    }
}
