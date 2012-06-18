class ganeti_tutorial::params {
    $htools_version = "0.3.1"
    $image_version  = "0.5.1"
    $gwm_version    = "0.8.1"
    $ubuntu_version = "11.10"
    $cirros_version = "0.3.0"
    $files          = "/vagrant/modules/ganeti_tutorial/files"

    # OS parameters 
    case $::osfamily {
        'RedHat': {
            $drbd8_utils_package_name   = "drbd83-utils"
            $fab_path                   = "/usr/bin/fab"
            $ganeti_init_source         = "puppet:///modules/ganeti_tutorial/ganeti.init.redhat"  
            $ghc_package_name           = "ghc"
            $iputils_arping             = "iputils"
            $kvm_package_name           = "qemu-kvm"
            $libghc_network_dev         = "ghc-network-devel"
            $libghc_parallel_dev        = "ghc-parallel-devel"
            $python_dev                 = "python-devel"
            $python_openssl             = "pyOpenSSL"
            $python_pyinotify           = "python-inotify"
            $python_pyparsing           = "pyparsing"
            $vim_package_name           = "vim-enhanced"
        }

        'Debian': {
            $drbd8_utils_package_name   = "drbd8-utils"
            $fab_path                   = "/usr/local/bin/fab"
            $ganeti_init_source         = "/root/src/ganeti-${ganeti_version}/doc/examples/ganeti.initd"  
            $ghc_package_name           = "ghc6"
            $iputils_arping             = "iputils-arping"
            $kvm_package_name           = "kvm"
            $libghc_network_dev         = "libghc6-network-dev"
            $libghc_parallel_dev        = "libghc6-parallel-dev"
            $python_dev                 = "python-dev"
            $python_openssl             = "python-openssl"
            $python_pyinotify           = "python-pyinotify"
            $python_pyparsing           = "python-pyparsing"
            $vim_package_name           = "vim"
        }
    }
}
