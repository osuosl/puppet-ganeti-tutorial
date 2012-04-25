# Ganeti Tutorial

class ganeti_tutorial {
    require ganeti_tutorial::params

    include ganeti_tutorial::install_deps
    include ganeti_tutorial::hosts
    include ganeti_tutorial::drbd

    file {
        "/root/.ssh":
            ensure  => directory;
        "/var/lib/ganeti":
            ensure  => directory;
        "/var/lib/ganeti/rapi/":
            require => File["/var/lib/ganeti"],
            ensure  => directory;
        "/root/puppet":
            ensure  => link,
            target  => "/vagrant/modules/ganeti_tutorial";
        "/var/lib/ganeti/rapi/users":
            ensure  => "present",
            mode    => 640,
            require => File["/var/lib/ganeti/rapi/"],
            source  => "${ganeti_tutorial::params::files}/rapi-users";
    }
}
