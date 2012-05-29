class ganeti_tutorial::htools {
    $htools_version         = $ganeti_tutorial::params::htools_version
    $ghc_package_name       = $ganeti_tutorial::params::ghc_package_name
    $libghc_network_dev     = $ganeti_tutorial::params::libghc_network_dev
    $libghc_parallel_dev    = $ganeti_tutorial::params::libghc_parallel_dev

    package {
        "ghc":
            ensure  => installed,
            name    => $ghc_package_name;
        "libghc6-network-dev":
            ensure  => installed,
            name    => $libghc_network_dev;
        "libghc6-parallel-dev":
            ensure  => installed,
            name    => $libghc_parallel_dev;
    }

    if $osfamily == "redhat" {
        ganeti_tutorial::cabal::install {
            "json":         version => "0.4.4";
            "curl":         require => Package["libcurl-devel"];
            "QuickCheck":   require => Package["ghc-ghc-devel"];
            "network": ; 
            "parallel": ;
        }
        package {
            "libcurl-devel":    ensure => installed;
            "ghc-ghc-devel":    ensure => installed;
        }
    } else {
        package {
            "libghc6-curl-dev":     ensure  => installed;
            "libghc6-json-dev":     ensure  => installed;
        }
    }

    if "$ganeti_version" < "2.5.0" {
        ganeti_tutorial::unpack {
            "htools":
                source  => "/root/src/ganeti-htools-${htools_version}.tar.gz",
                cwd     => "/root/src",
                creates => "/root/src/ganeti-htools-${htools_version}",
                require => File["/root/src"];
        }

        exec {
            "install-htools":
                command => "/vagrant/modules/ganeti_tutorial/files/scripts/install-htools",
                cwd     => "/root/src/ganeti-htools-${htools_version}",
                creates => "/usr/local/sbin/hbal",
                require => [ Package["ghc"], Package["libghc6-json-dev"],
                    Package["libghc6-network-dev"], Package["libghc6-parallel-dev"],
                    Package["libghc6-curl-dev"], Ganeti_tutorial::Unpack["htools"],];
        }
    }
}
