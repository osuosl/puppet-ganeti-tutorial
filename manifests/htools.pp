class ganeti_tutorial::htools {
  $htools_version         = $ganeti_tutorial::params::htools_version
  $ghc_package_name       = $ganeti_tutorial::params::ghc_package_name
  $libghc_curl_dev        = $ganeti_tutorial::params::libghc_curl_dev
  $libghc_json_dev        = $ganeti_tutorial::params::libghc_json_dev
  $libghc_network_dev     = $ganeti_tutorial::params::libghc_network_dev
  $libghc_parallel_dev    = $ganeti_tutorial::params::libghc_parallel_dev

  package {
    "ghc":
      ensure  => installed,
      name    => $ghc_package_name;
    "libghc6-curl-dev":
      ensure  => installed,
      name    => $libghc_curl_dev;
    "libghc6-json-dev":
      ensure  => installed,
      name    => $libghc_json_dev;
    "libghc6-network-dev":
      ensure  => installed,
      name    => $libghc_network_dev;
    "libghc6-parallel-dev":
      ensure  => installed,
      name    => $libghc_parallel_dev;
  }

  if "$ganeti_version" < "2.5.0" {
    ganeti_tutorial::unpack {
      "htools":
        source  => "/root/src/ganeti-htools-${htools_version}.tar.gz",
        cwd     => "/root/src",
        creates => "/root/src/ganeti-htools-${htools_version}",
        require => Ganeti_tutorial::Wget["htools-tgz"];
    }

    ganeti_tutorial::wget {
      "htools-tgz":
        source      => "http://ganeti.googlecode.com/files/ganeti-htools-${htools_version}.tar.gz",
        destination => "/root/src/ganeti-htools-${htools_version}.tar.gz",
        require     => File["/root/src"];
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
