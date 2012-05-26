class ganeti_tutorial::ganeti::install {
    require ganeti_tutorial::params
    include ganeti_tutorial::htools

    $ganeti_version = "${ganeti_tutorial::params::ganeti_version}"
    $script_path    = "/vagrant/modules/ganeti_tutorial/files/scripts"

    file {
        "/etc/init.d/ganeti":
            ensure  => present,
            require => Exec["install-ganeti"],
            source  => "/root/src/ganeti-${ganeti_version}/doc/examples/ganeti.initd",
            mode    => 755;
        "/etc/ganeti":
            ensure  => directory;
        "/etc/ganeti/kvm-vif-bridge":
            ensure  => present,
            require => File["/etc/ganeti"],
            content => "";
    }

    if $git {
        vcsrepo {
            "/root/src/ganeti-${ganeti_version}":
                ensure      => present,
                provider    => git,
                source      => "git://git.ganeti.org/ganeti.git",
                revision    => "${ganeti_version}";
        }
    } else {
        ganeti_tutorial::unpack {
            "ganeti":
                source      => "/root/src/ganeti-${ganeti_version}.tar.gz",
                cwd         => "/root/src/",
                creates     => "/root/src/ganeti-${ganeti_version}",
                require     => File["/root/src"];
        }
    }

    if "$ganeti_version" < "2.5.0" {
        exec {
            "install-ganeti":
                command => "${script_path}/install-ganeti",
                cwd     => "/root/src/ganeti-${ganeti_version}",
                creates => "/usr/local/sbin/gnt-cluster",
                require => Ganeti_tutorial::Unpack["ganeti"];
        }
    } else {
        exec {
            "install-ganeti":
                command =>
                    "${script_path}/install-ganeti --enable-htools --enable-htools-rapi",
                cwd     => "/root/src/ganeti-${ganeti_version}",
                creates => "/usr/local/sbin/gnt-cluster",
                require => [ Ganeti_tutorial::Unpack["ganeti"], Package["ghc6"],
                        Package["libghc6-json-dev"],
                        Package["libghc6-network-dev"],
                        Package["libghc6-parallel-dev"],
                        Package["libghc6-curl-dev"], ];
        }
    }

    service {
        "ganeti":
            enable      => true,
            require     => File["/etc/init.d/ganeti"],
    }
}

class ganeti_tutorial::ganeti::initialize inherits ganeti_tutorial::ganeti::install {
    exec {
        "initialize-ganeti":
            command => "/vagrant/modules/ganeti_tutorial/files/scripts/initialize-ganeti",
            creates => "/var/lib/ganeti/config.data",
            require => [
                Exec["install-ganeti"], Exec["ifup_br0"], Exec["ifup_eth2"],
                Exec["modprobe_drbd"], ],
    }
}

class ganeti_tutorial::ganeti::git inherits ganeti_tutorial::ganeti::install {
        package {
            "automake":         ensure => present;
            "autoconf":         ensure => present;
            "pandoc":           ensure => present;
            "python-docutils":  ensure => present;
            "python-sphinx":    ensure => present;
            "graphviz":         ensure => present;
        }

        Exec["install-ganeti"] {
                require => [ Vcsrepo["/root/src/ganeti-${ganeti_version}"],
                        Package["ghc6"],
                        Package["libghc6-json-dev"],
                        Package["libghc6-network-dev"],
                        Package["libghc6-parallel-dev"],
                        Package["libghc6-curl-dev"],
                        Package["automake"], Package["autoconf"],
                        Package["pandoc"], Package["graphviz"],
                        Package["python-docutils"], Package["python-sphinx"], ],
        }
}
