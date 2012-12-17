class ganeti_tutorial::params {
  $image_version  = "0.5.1"
  $gwm_version    = "0.8.1"
  $ubuntu_version = "11.10"
  $cirros_version = "0.3.0"
  $files          = "/vagrant/modules/ganeti_tutorial/files"

  if "$ganeti_version" < "2.4.0" {
    $htools_version = "0.2.8"
  } else {
    $htools_version = "0.3.1"
  }

  # OS parameters 
  case $::osfamily {
    'RedHat': {
      $drbd8_utils_package_name = "drbd83-utils"
      $fab_path                 = "/usr/bin/fab"
      $ganeti_init_source       = "puppet:///modules/ganeti_tutorial/ganeti.init.redhat"  
      $ghc_package_name         = "ghc"
      $gii_26_patch             = "2.6-support-redhat.patch"
      $iputils_arping           = "iputils"
      $kvm_package_name         = "qemu-kvm"
      $libghc_curl_dev          = "ghc-curl-devel"
      $libghc_json_dev          = "ghc-json-devel"
      $libghc_network_dev       = "ghc-network-devel"
      $libghc_parallel_dev      = "ghc-parallel-devel"
      $python_dev               = "python-devel"
      $python_openssl           = "pyOpenSSL"
      $python_pyinotify         = "python-inotify"
      $python_pyparsing         = "pyparsing"
      $vim_package_name         = "vim-enhanced"
    }

    'Debian': {
      $drbd8_utils_package_name = "drbd8-utils"
      $fab_path                 = "/usr/local/bin/fab"
      $ganeti_init_source       = "/root/src/ganeti-${ganeti_version}/doc/examples/ganeti.initd"  
      $ghc_package_name         = "ghc6"
      $gii_26_patch             = "2.6-support.patch"
      $iputils_arping           = "iputils-arping"
      $kvm_package_name         = "kvm"
      $libghc_curl_dev          = "libghc6-curl-dev"
      $libghc_json_dev          = "libghc6-json-dev"
      $libghc_network_dev       = "libghc6-network-dev"
      $libghc_parallel_dev      = "libghc6-parallel-dev"
      $python_dev               = "python-dev"
      $python_openssl           = "python-openssl"
      $python_pyinotify         = "python-pyinotify"
      $python_pyparsing         = "python-pyparsing"
      $vim_package_name         = "vim"
    }
  }

  if $operatingsystem == "Ubuntu" {
    case $operatingsystemrelease {
      12.04: { $pycurl_deb = "python-pycurl_7.19.0-4ubuntu4~precise1_amd64.deb" }
      12.10: { $pycurl_deb = "python-pycurl_7.19.0-5ubuntu2_amd64.deb" }
    }
  }
}
