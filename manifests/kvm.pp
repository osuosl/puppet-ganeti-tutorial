class ganeti_tutorial::kvm {
  $kvm_package_name = $ganeti_tutorial::params::kvm_package_name

  package {
    "kvm":  ensure => installed, name => $kvm_package_name;
  }

  file {
    "/boot/vmlinuz-kvmU":
      ensure  => link,
      target  => "/boot/vmlinuz-${kernelrelease}";
    "/boot/initrd-kvmU":
      ensure  => link,
      target  => $osfamily ? {
        debian  => "/boot/initrd.img-${kernelrelease}",
        redhat  => "/boot/initramfs-${kernelrelease}.img",
      }
  }

  if $osfamily == "debian" {
    service {
      "qemu-kvm":
        enable  => false,
        require => Package["kvm"],
    }
  }
}
