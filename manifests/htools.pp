class ganeti_tutorial::htools {
    require ganeti_tutorial::params

    $htools_version  = "${ganeti_tutorial::params::htools_version}"

    package {
        "ghc6":                 ensure  => installed;
        "libghc6-json-dev":     ensure  => installed;
        "libghc6-network-dev":  ensure  => installed;
        "libghc6-parallel-dev": ensure  => installed;
        "libghc6-curl-dev":     ensure  => installed;
    }

    ganeti_tutorial::unpack {
        "htools":
            source  => "/root/src/ganeti-htools-${htools_version}.tar.gz",
            cwd     => "/root/src",
            creates => "/root/src/ganeti-htools-${htools_version}",
            require => File["/root/src"];
    }
}
