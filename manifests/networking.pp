class ganeti_tutorial::networking {
    file { "/etc/network/interfaces":
        ensure  => present,
        content => template("ganeti_tutorial/interfaces.erb"),
        notify  => [ Exec["ifup_br0"], Exec["ifup_eth2"] ],
    }

    exec {
        "ifup_br0":
            command     => "/sbin/ifup br0",
            refreshonly => true,
            require     => File["/etc/network/interfaces"];
        "ifup_eth2":
            command     => "/sbin/ifup eth2",
            refreshonly => true,
            require     => File["/etc/network/interfaces"];
    }
}
