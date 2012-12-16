class ganeti_tutorial::install_deps {
  $iputils_arping   = $ganeti_tutorial::params::iputils_arping
  $python_openssl   = $ganeti_tutorial::params::python_openssl
  $python_pyinotify = $ganeti_tutorial::params::python_pyinotify
  $python_pyparsing = $ganeti_tutorial::params::python_pyparsing
  $vim_package_name = $ganeti_tutorial::params::vim_package_name

  package {
    # Ganeti deps
    "bridge-utils":     ensure => installed;
    "iproute":          ensure => installed;
    "iputils-arping":   ensure => installed, name => $iputils_arping;
    "lvm2":             ensure => installed;
    "make":             ensure => installed;
    "ndisc6":           ensure => installed;
    "openssl":          ensure => installed;
    "patch":            ensure => installed;
    "python-openssl":   ensure => installed, name => $python_openssl;
    "python-paramiko":  ensure => installed;
    "python-pyinotify": ensure => installed, name => $python_pyinotify;
    "python-pyparsing": ensure => installed, name => $python_pyparsing;
    "python-simplejson": ensure => installed;
    "socat":            ensure => installed;
    # Misc
    "git":              ensure => installed;
    "screen":           ensure => installed;
    "vim":              ensure => installed, name => $vim_package_name
    }

  # Install pycurl linked against openssl instead of gnutls
  if ($operatingsystem == "Ubuntu") and ($operatingsystemrelease >= "12.04") {
    ganeti_tutorial::wget {
      "pycurl-ubuntu-dpkg":
        source      => "http://ftp.osuosl.org/pub/osl/ganeti-tutorial/python-pycurl_7.19.0-4ubuntu4~precise1_amd64.deb",
        destination => "/root/src/python-pycurl.deb",
        require     => File["/root/src"];
    }

    package {
      "libcurl3":   ensure => installed;
      "python-pycurl":
        provider    => "dpkg",
        source      => "/root/src/python-pycurl.deb",
        ensure      => "latest",
        require     => [ Ganeti_tutorial::Wget["pycurl-ubuntu-dpkg"],
          Package["libcurl3"] ];
    }
  } else {
    package { "python-pycurl":    ensure => installed; }
  }

  file {
    "/root/src":
      ensure  => present,
      source  => "puppet:///modules/ganeti_tutorial/src/",
      require => Package["make"],
      recurse => true;
  }
}
