class ganeti_tutorial::hosts {
    host {
        "ganeti.example.org":
            ensure          => present,
            host_aliases    => "ganeti",
            ip              => "33.33.33.10";
        "node1.example.org":
            ensure          => present,
            host_aliases    => "node1",
            ip              => "33.33.33.11";
        "node2.example.org":
            ensure          => present,
            host_aliases    => "node2",
            ip              => "33.33.33.12";
        "node3.example.org":
            ensure          => present,
            host_aliases    => "node3",
            ip              => "33.33.33.13";
        "instance1.example.org":
            ensure          => present,
            host_aliases    => "instance1",
            ip              => "33.33.33.31";
        "instance2.example.org":
            ensure          => present,
            host_aliases    => "instance2",
            ip              => "33.33.33.32";
        "instance3.example.org":
            ensure          => present,
            host_aliases    => "instance3",
            ip              => "33.33.33.33";
        "instance4.example.org":
            ensure          => present,
            host_aliases    => "instance4",
            ip              => "33.33.33.34";
    }
}
