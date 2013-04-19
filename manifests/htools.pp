class ganeti_tutorial::htools {
  $htools_version         = $ganeti_tutorial::params::htools_version
  include ganeti_tutorial::htools::install_deps

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
        require => [ Package["ghc"], Package["libghc-attoparsec-dev"],
          Package["libghc-crypto-dev"], Package["libghc-curl-dev"],
          Package["libghc-deepseq-dev"], Package["libghc-hinotify-dev"],
          Package["libghc-hslogger-dev"], Package["libghc-json-dev"],
          Package["libghc-network-dev"], Package["libghc-parallel-dev"],
          Package["libghc-regex-pcre-dev"], Package["libghc-utf8-string"],
          Package["libghc-vector-dev"], Package["libpcre-dev"],
          Ganeti_tutorial::Unpack["htools"],];
    }
  }
  case $osfamily {
    redhat:   { include ganeti_tutorial::redhat::htools }
    default:  { }
  }
}

class ganeti_tutorial::htools::install_deps {
  $ghc_package_name       = $ganeti_tutorial::params::ghc_package_name
  $libghc_attoparsec_dev  = $ganeti_tutorial::params::libghc_attoparsec_dev
  $libghc_crypto_dev      = $ganeti_tutorial::params::libghc_crypto_dev
  $libghc_curl_dev        = $ganeti_tutorial::params::libghc_curl_dev
  $libghc_deepseq_dev     = $ganeti_tutorial::params::libghc_deepseq_dev
  $libghc_hinotify_dev    = $ganeti_tutorial::params::libghc_hinotify_dev
  $libghc_hslogger_dev    = $ganeti_tutorial::params::libghc_hslogger_dev
  $libghc_json_dev        = $ganeti_tutorial::params::libghc_json_dev
  $libghc_network_dev     = $ganeti_tutorial::params::libghc_network_dev
  $libghc_parallel_dev    = $ganeti_tutorial::params::libghc_parallel_dev
  $libghc_regex_pcre_dev  = $ganeti_tutorial::params::libghc_regex_pcre_dev
  $libghc_utf8_string_dev = $ganeti_tutorial::params::libghc_utf8_string_dev
  $libghc_vector_dev      = $ganeti_tutorial::params::libghc_vector_dev
  $libpcre_dev            = $ganeti_tutorial::params::libpcre_dev

  package {
    "ghc":
      ensure  => installed,
      name    => $ghc_package_name;
    "libghc-attoparsec-dev":
      ensure  => installed,
      name    => $libghc_attoparsec_dev;
    "libghc-crypto-dev":
      ensure  => installed,
      name    => $libghc_crypto_dev;
    "libghc-curl-dev":
      ensure  => installed,
      name    => $libghc_curl_dev;
    "libghc-deepseq-dev":
      ensure  => installed,
      name    => $libghc_deepseq_dev;
    "libghc-hinotify-dev":
      ensure  => installed,
      name    => $libghc_hinotify_dev;
    "libghc-hslogger-dev":
      ensure  => installed,
      name    => $libghc_hslogger_dev;
    "libghc-json-dev":
      ensure  => installed,
      name    => $libghc_json_dev;
    "libghc-network-dev":
      ensure  => installed,
      name    => $libghc_network_dev;
    "libghc-parallel-dev":
      ensure  => installed,
      name    => $libghc_parallel_dev;
    "libghc-regex-pcre-dev":
      ensure  => installed,
      name    => $libghc_regex_pcre_dev;
    "libghc-utf8-string-dev":
      ensure  => installed,
      name    => $libghc_utf8_string_dev;
    "libghc-vector-dev":
      ensure  => installed,
      name    => $libghc_vector_dev;
    "libpcre-dev":
      ensure  => installed,
      name    => $libpcre_dev;
  }
}
