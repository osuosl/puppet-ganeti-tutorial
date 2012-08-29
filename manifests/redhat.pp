class ganeti_tutorial::redhat {
  include ganeti_tutorial::cabal
  include ganeti_tutorial::redhat::drbd
  include ganeti_tutorial::redhat::htools
  include ganeti_tutorial::redhat::ganeti
  include ganeti_tutorial::redhat::ganeti::initialize
  include ganeti_tutorial::redhat::kvm
}

class ganeti_tutorial::redhat::drbd inherits ganeti_tutorial::drbd {
  yumrepo {
    "elrepo":
      baseurl         => "http://elrepo.org/linux/elrepo/el6/\$basearch/",
      mirrorlist      => "http://elrepo.org/mirrors-elrepo.el6",
      enabled         => "1",
      gpgcheck        => "1",
      gpgkey          => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org",
      require         => File["RPM-GPG-KEY-elrepo.org"];
  }

  file {
    "RPM-GPG-KEY-elrepo.org":
      path    => "/etc/pki/rpm-gpg/RPM-GPG-KEY-elrepo.org",
      ensure  => present,
      source  => "puppet:///modules/ganeti_tutorial/RPM-GPG-KEY-elrepo.org";
  }

  package {
    "kmod-drbd83":
      ensure  => installed,
      require => Yumrepo["elrepo"];
  }

  Package["drbd8-utils"] {
    require => Yumrepo["elrepo"],
  }

  Exec["modprobe_drbd"] {
    require => [
      File["/etc/modprobe.d/local.conf"],
      Package["drbd8-utils"],
      Package["kmod-drbd83"],
      Yumrepo["elrepo"], ],
  }

}

class ganeti_tutorial::redhat::htools inherits ganeti_tutorial::htools {
  if "$ganeti_version" < "2.5.0" {
    Exec["install-htools"] {
      require => [ Package["ghc"],
        Ganeti_tutorial::Cabal::Install["json"],
        Ganeti_tutorial::Cabal::Install["curl"],
        Ganeti_tutorial::Cabal::Install["network"],
        Ganeti_tutorial::Cabal::Install["QuickCheck"],
        Ganeti_tutorial::Cabal::Install["parallel"],
        Ganeti_tutorial::Unpack["htools"], ],
    }
  }
}

class ganeti_tutorial::redhat::ganeti inherits ganeti_tutorial::ganeti::install {

  if "$ganeti_version" >= "2.5.0" {
    Exec["install-ganeti"] {
      require => [ Package["ghc"],
        Ganeti_tutorial::Cabal::Install["json"],
        Ganeti_tutorial::Cabal::Install["curl"],
        Ganeti_tutorial::Cabal::Install["network"],
        Ganeti_tutorial::Cabal::Install["QuickCheck"],
        Ganeti_tutorial::Cabal::Install["parallel"], 
        Ganeti_tutorial::Unpack["ganeti"],
        Exec["patch-daemon-util"], ],
    }
  }

  File["/etc/init.d/ganeti"] {
    require => [ Exec["install-ganeti"], File["/etc/sysconfig/ganeti"], ],
  }

  exec {
    "patch-daemon-util":
      command => "/usr/bin/patch -p1 < ${ganeti_tutorial::params::files}/src/daemon-util.patch",
      cwd     => "/root/src/ganeti-${ganeti_version}",
      unless  => "/bin/grep daemonexec /root/src/ganeti-${ganeti_version}/daemons/daemon-util.in",
      require => [ Ganeti_tutorial::Unpack["ganeti"], Package["patch"], ];
  }

  package { "patch": ensure => installed; }

  file {
    "/etc/sysconfig/ganeti":
      ensure  => present,
      source  => "${ganeti_tutorial::params::files}/ganeti.sysconfig",
  }
}

class ganeti_tutorial::redhat::ganeti::initialize inherits ganeti_tutorial::ganeti::initialize {
  file {
    "/usr/lib/python2.6/site-packages/ganeti":
      ensure => link,
      target => "/usr/local/lib/python2.6/site-packages/ganeti";
  }
  Exec["initialize-ganeti"] {
    require => [ Exec["install-ganeti"], Exec["ifup_br0"],
      Exec["ifup_eth2"], Exec["modprobe_drbd"],
      File["/usr/lib/python2.6/site-packages/ganeti"], ],
  }
}

class ganeti_tutorial::redhat::kvm inherits ganeti_tutorial::kvm {
  file {
    "/usr/bin/kvm":
      ensure  => link,
      target  => "/usr/libexec/qemu-kvm",
  }
}

class ganeti_tutorial::redhat::gwm inherits ganeti_tutorial::gwm {
  Package["fabric"] {
    require => [ Package["python-pip"], File["/usr/local/bin/pip"], ],
  }
  Package["virtualenv"] {
    require => [ Package["python-pip"], File["/usr/local/bin/pip"], ],
  }
}
