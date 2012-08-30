class ganeti_tutorial::redhat {
  include ganeti_tutorial::redhat::drbd
  include ganeti_tutorial::redhat::htools
  include ganeti_tutorial::redhat::ganeti
  include ganeti_tutorial::redhat::ganeti::initialize
  include ganeti_tutorial::redhat::kvm

  yumrepo {
    "ganeti":
      baseurl         => "http://ftp.osuosl.org/pub/osl/ganeti-centos-6/\$basearch/",
      enabled         => "1",
      gpgcheck        => "0";
  }
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
  Package["libghc6-curl-dev"] {
    require => Yumrepo["ganeti"],
  }

  package {
    "libcurl-devel": ensure => installed;
  }
}

class ganeti_tutorial::redhat::ganeti inherits ganeti_tutorial::ganeti::install {

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
  file {
    "/usr/local/bin/pip":
      ensure  => link,
      target  => "/usr/bin/pip-python",
      require => Package["python-pip"],
  }

  Package["fabric"] {
    require => [ Package["python-pip"], File["/usr/local/bin/pip"], ],
  }
  Package["virtualenv"] {
    require => [ Package["python-pip"], File["/usr/local/bin/pip"], ],
  }
}
