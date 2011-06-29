class ganeti_tutorial::hosts {
    host {
        "ganeti.example.org":
            ensure          => present,
            ip              => "10.0.2.15";
        "node1.example.org":
            ensure          => present,
            ip              => "10.0.2.16";
        "node2.example.org":
            ensure          => present,
            ip              => "10.0.2.17";
        "instance1.example.org":
            ensure          => present,
            ip              => "10.0.2.30";
        "instance2.example.org":
            ensure          => present,
            ip              => "10.0.2.30";
    }
}
