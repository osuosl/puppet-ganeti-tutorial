class ganeti_tutorial::hosts {
    host {
        "ganeti.example.org":
            ensure          => present,
            ip              => "10.1.0.15";
        "node1.example.org":
            ensure          => present,
            ip              => "10.1.0.16";
        "node2.example.org":
            ensure          => present,
            ip              => "10.1.0.17";
        "instance1.example.org":
            ensure          => present,
            ip              => "10.1.0.30";
        "instance2.example.org":
            ensure          => present,
            ip              => "10.1.0.30";
    }
}
