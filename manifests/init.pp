# Ganeti Tutorial

class ganeti_tutorial {
    include ganeti_tutorial::install_deps
    include ganeti_tutorial::hosts
    include ganeti_tutorial::networking

    file { "/root/.ssh": ensure => directory, }
}
