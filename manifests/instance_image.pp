class ganeti_tutorial::instance_image {
  $cirros_version = $ganeti_tutorial::params::cirros_version

  package {
    "ganeti-instance-image": ensure => installed;
  }

  file {
    "/etc/default/ganeti-instance-image":
      ensure  => present,
      require => Package["ganeti-instance-image"],
      content => template("ganeti_tutorial/instance-image/defaults.erb");
    "/etc/ganeti/instance-image/variants.list":
      ensure  => present,
      require => Package["ganeti-instance-image"],
      source  => "${ganeti_tutorial::params::files}/instance-image/variants.list";
    "/etc/ganeti/instance-image/variants/cirros.conf":
      ensure  => present,
      require => Package["ganeti-instance-image"],
      source  => "${ganeti_tutorial::params::files}/instance-image/cirros.conf";
    "/etc/ganeti/instance-image/variants/default.conf":
      ensure  => "/etc/ganeti/instance-image/variants/cirros.conf",
      require => [ Package["ganeti-instance-image"],
        File["/etc/ganeti/instance-image/variants/cirros.conf"] ];
    "/etc/ganeti/instance-image/hooks/interfaces":
      mode    => 755,
      require => Package["ganeti-instance-image"];
    "/etc/ganeti/instance-image/hooks/zz_no-net":
      ensure  => present,
      mode    => 755,
      require => Package["ganeti-instance-image"],
      source  => "puppet:///modules/ganeti_tutorial/instance-image/hooks/zz_no-net";
  }

  ganeti_tutorial::wget {
    "cirros-root":
      require     => Package["ganeti-instance-image"],
      source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/cirros-${cirros_version}-${hardwaremodel}.tar.gz",
      destination => "/var/cache/ganeti-instance-image/cirros-${cirros_version}-${hardwaremodel}.tar.gz";
  }
}

class ganeti_tutorial::instance_image::ubuntu {
  $ubuntu_version = "${ganeti_tutorial::params::ubuntu_version}"

  file {
    "/etc/ganeti/instance-image/variants/ubuntu-12.04.conf":
      ensure  => present,
      require => Package["ganeti-instance-image"],
      source  => "${ganeti_tutorial::params::files}/instance-image/ubuntu-12.04.conf";
  }

  ganeti_tutorial::wget {
    "ubuntu-root":
      require     => Package["ganeti-instance-image"],
      source      => "http://staff.osuosl.org/~ramereth/ganeti-tutorial/ubuntu-${ubuntu_version}-${hardwaremodel}.tar.gz",
      destination => "/var/cache/ganeti-instance-image/ubuntu-${ubuntu_version}-${hardwaremodel}.tar.gz";
  }
}
