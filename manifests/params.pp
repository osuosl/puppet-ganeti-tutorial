class ganeti_tutorial::params {
  $gwm_version    = "0.8.1"
  $ubuntu_version = "12.04.2"
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
      $libghc_attoparsec_dev    = "ghc-attoparsec-devel"
      $libghc_crypto_dev        = "ghc-Crypto-devel"
      $libghc_curl_dev          = "ghc-curl-devel"
      $libghc_deepseq_dev       = "ghc-deepseq-devel"
      $libghc_hslogger_dev      = "ghc-hslogger-devel"
      $libghc_json_dev          = "ghc-json-devel"
      $libghc_network_dev       = "ghc-network-devel"
      $libghc_parallel_dev      = "ghc-parallel-devel"
      $libghc_utf8_string_dev   = "ghc-utf8-string-devel"
      $libghc_vector_dev        = "ghc-vector-devel"
      $libpcre_dev              = "pcre-devel"
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
      $libghc_attoparsec_dev    = "libghc-attoparsec-dev"
      $libghc_crypto_dev        = "libghc-crypto-dev"
      $libghc_curl_dev          = "libghc-curl-dev"
      $libghc_deepseq_dev       = "libghc6-deepseq-dev"
      $libghc_hslogger_dev      = "libghc-hslogger-dev"
      $libghc_json_dev          = "libghc-json-dev"
      $libghc_network_dev       = "libghc-network-dev"
      $libghc_parallel_dev      = "libghc-parallel-dev"
      $libghc_utf8_string       = "libghc-utf8-string-dev"
      $libghc_vector_dev        = "libghc-vector-dev"
      $libpcre_dev              = "libpcre3-dev"
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
