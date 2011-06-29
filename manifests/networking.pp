class ganeti_tutorial::networking {
    file { "/etc/network/interfaces":
        ensure  => present,
        content => template("ganeti_tutorial/interfaces.erb"),
    }
}
