class ganeti_tutorial::hosts {
    host {
        "ganeti.example.org":
            ensure          => present,
            host_aliases    => "ganeti",
            ip              => "10.1.0.15";
        "node1.example.org":
            ensure          => present,
            host_aliases    => "node1",
            ip              => "10.1.0.16";
        "node2.example.org":
            ensure          => present,
            host_aliases    => "node2",
            ip              => "10.1.0.17";
        "instance1.example.org":
            ensure          => present,
            host_aliases    => "instance1",
            ip              => "10.1.0.30";
        "instance2.example.org":
            ensure          => present,
            host_aliases    => "instance2",
            ip              => "10.1.0.31";
        "instance3.example.org":
            ensure          => present,
            host_aliases    => "instance3",
            ip              => "10.1.0.32";
        "instance4.example.org":
            ensure          => present,
            host_aliases    => "instance4",
            ip              => "10.1.0.33";
    }
}
