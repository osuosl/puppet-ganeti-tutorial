# Ganeti Tutorial

class ganeti_tutorial {
    include ganeti_tutorial::install_deps
    include ganeti_tutorial::hosts
    include ganeti_tutorial::networking

    file {
        "/root/.ssh":
            ensure  => directory;
        "/boot/vmlinuz-2.6-kvmU":
            ensure  => link,
            target  => "/boot/vmlinuz-2.6.32-5-amd64";
        "/boot/initrd-2.6-kvmU":
            ensure  => link,
            target  => "/boot/initrd-2.6.32-5-amd64";
    }
}
