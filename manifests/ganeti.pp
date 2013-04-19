class ganeti_tutorial::ganeti::install {
  include ganeti_tutorial::htools

  $ganeti_init_source = $ganeti_tutorial::params::ganeti_init_source
  $files              = $ganeti_tutorial::params::files

  file {
    "/etc/init.d/ganeti":
      ensure  => present,
      require => Exec["install-ganeti"],
      source  => $ganeti_init_source,
      mode    => 755;
    "/etc/ganeti":
      ensure  => directory;
    "/etc/ganeti/kvm-vif-bridge":
      ensure  => present,
      require => File["/etc/ganeti"],
      content => "";
  }

  if $git {
    vcsrepo {
      "/root/src/ganeti-${ganeti_version}":
        ensure    => present,
        provider  => "git",
        source    => "git://git.ganeti.org/ganeti.git",
        revision  => "${ganeti_version}";
    }
  } else {
    ganeti_tutorial::unpack {
      "ganeti":
        source  => "/root/src/ganeti-${ganeti_version}.tar.gz",
        cwd     => "/root/src/",
        creates => "/root/src/ganeti-${ganeti_version}",
        require => Ganeti_tutorial::Wget["ganeti-tgz"];
    }
  }

  if "$ganeti_version" < "2.5.0" {
    exec {
      "install-ganeti":
        command => "${files}/scripts/install-ganeti",
        cwd     => "/root/src/ganeti-${ganeti_version}",
        creates => "/usr/local/sbin/gnt-cluster",
        require => Ganeti_tutorial::Unpack["ganeti"];
    }
  } else {
    exec {
      "install-ganeti":
        command =>
          "${files}/scripts/install-ganeti --enable-htools --enable-htools-rapi",
        cwd     => "/root/src/ganeti-${ganeti_version}",
        creates => "/usr/local/sbin/gnt-cluster",
        require => [ Ganeti_tutorial::Unpack["ganeti"], Package["ghc"],
          Package["libghc-attoparsec-dev"],Package["libghc-crypto-dev"],
          Package["libghc-curl-dev"], Package["libghc-deepseq-dev"],
          Package["libghc-hinotify-dev"], Package["libghc-hslogger-dev"],
          Package["libghc-json-dev"], Package["libghc-network-dev"],
          Package["libghc-parallel-dev"], Package["libghc-regex-pcre-dev"],
          Package["libghc-utf8-string-dev"], Package["libghc-vector-dev"],
          Package["libpcre-dev"], ];
    }
  }

  ganeti_tutorial::wget {
    "ganeti-tgz":
      source      => "http://ganeti.googlecode.com/files/ganeti-${ganeti_version}.tar.gz",
      destination => "/root/src/ganeti-${ganeti_version}.tar.gz",
      require     => File["/root/src"];
  }


  service {
    "ganeti":
      enable  => true,
      require => File["/etc/init.d/ganeti"],
  }

  case $osfamily {
    redhat:   { include ganeti_tutorial::redhat::ganeti }
    default:  { }
  }
}

class ganeti_tutorial::ganeti::initialize inherits ganeti_tutorial::ganeti::install {
  exec {
    "initialize-ganeti":
      command => "${files}/scripts/initialize-ganeti",
      creates => "/var/lib/ganeti/config.data",
      require => [
        Exec["install-ganeti"], Exec["ifup_br0"], Exec["ifup_eth2"],
        Exec["modprobe_drbd"], ],
  }
  case $osfamily {
    redhat:   { include ganeti_tutorial::redhat::ganeti::initialize }
    default:  { }
  }
}

class ganeti_tutorial::ganeti::git inherits ganeti_tutorial::ganeti::install {
  package {
    "automake":         ensure => present;
    "autoconf":         ensure => present;
    "pandoc":           ensure => present;
    "python-docutils":  ensure => present;
    "python-sphinx":    ensure => present;
    "graphviz":         ensure => present;
  }

  Exec["install-ganeti"] {
    require => [ Vcsrepo["/root/src/ganeti-${ganeti_version}"],
      Package["ghc"], Package["libghc-attoparsec-dev"],
      Package["libghc-crypto-dev"], Package["libghc-curl-dev"],
      Package["libghc-deepseq-dev"], Package["libghc-hinotify-dev"],
      Package["libghc-hslogger-dev"], Package["libghc-json-dev"],
      Package["libghc-network-dev"], Package["libghc-parallel-dev"],
      Package["libghc-regex-pcre-dev"], Package["libghc-utf8-string-dev"],
      Package["libghc-vector-dev"], Package["libpcre-dev"], Package["automake"],
      Package["autoconf"], Package["pandoc"], Package["graphviz"],
      Package["python-docutils"], Package["python-sphinx"],
      ],
  }
}
