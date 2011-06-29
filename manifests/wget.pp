define ganeti_tutorial::wget($source, $destination) {
    exec { "wget-$name":
        command => "/usr/bin/wget -O $destination $source",
        creates => "$destination",
    }
}
