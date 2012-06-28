class ganeti_tutorial::puppet {
  $deb_dir = "/vagrant/modules/ganeti_tutorial/files/deb"
  package {
    "puppet-common":
      ensure    => latest,
      provider  => "dpkg",
      source    => "${deb_dir}/puppet-common_2.7.0~rc4-1_all.deb";
    "puppet":
      ensure    => latest,
      provider  => dpkg,
      require   => Package["puppet-common"],
      source    => "${deb_dir}/puppet_2.7.0~rc4-1_all.deb";
  }

  service {
    "puppet":
      enable    => false,
      require   => Package["puppet"],
  }
}
