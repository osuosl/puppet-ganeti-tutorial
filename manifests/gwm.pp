class ganeti_tutorial::gwm {
  $python_dev  = $ganeti_tutorial::params::python_dev
  $gwm_version = $ganeti_tutorial::params::gwm_version
  $fab_path    = $ganeti_tutorial::params::fab_path

  package {
    "python-dev":   ensure => "installed", name => $python_dev, ;
    "fabric":
      ensure    => "installed",
      require   => Package["python-pip"],
      provider  => "pip";
    "virtualenv":
      ensure    => "installed",
      require   => Package["python-pip"],
      provider  => "pip";
  }

  ganeti_tutorial::unpack {
    "gwm":
      source  => "/root/src/ganeti-webmgr-${gwm_version}.tar.gz",
      cwd     => "/root/",
      creates => "/root/ganeti_webmgr",
      require => File["/root/src"];
  }

  file {
    "/root/ganeti_webmgr/settings.py":
      ensure  => present,
      source  => "/root/ganeti_webmgr/settings.py.dist",
      require => Ganeti_Tutorial::Unpack["gwm"];
    "/etc/init.d/vncap":
      ensure  => present,
      source  => "puppet:///modules/ganeti_tutorial/gwm/vncap",
      mode    => 755;
    "/etc/init.d/flashpolicy":
      ensure  => present,
      source  => "puppet:///modules/ganeti_tutorial/gwm/flashpolicy",
      mode    => 755;
  }

  exec { 
    "deploy-gwm":
      command => "$fab_path prod deploy",
      cwd     => "/root/ganeti_webmgr",
      timeout => "400",
      creates => "/root/ganeti_webmgr/bin/activate",
      require => [ Package["fabric"], Package["virtualenv"], 
        Package["python-dev"], Exec["unpack-gwm"] ];
  }

  service {
    "vncap":
      enable  => true,
      require => [ File["/etc/init.d/vncap"], Exec["deploy-gwm"], ];
    "flashpolicy":
      enable  => true,
      require => [ File["/etc/init.d/flashpolicy"], Exec["deploy-gwm"], ];
  }

  case $osfamily {
    redhat:   { include ganeti_tutorial::redhat::gwm }
    default:  { }
  }
}

class ganeti_tutorial::gwm::initialize {
  $files       = $ganeti_tutorial::params::files

  exec {
    "syncdb-gwm":
      command => "${files}/scripts/syncdb-gwm",
      cwd     => "/root/ganeti_webmgr",
      creates => "/root/ganeti_webmgr/ganeti.db",
      require => Exec["deploy-gwm"];
  }
}
