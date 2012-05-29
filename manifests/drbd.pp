class ganeti_tutorial::drbd inherits ganeti_tutorial::params {
    $package_name = $ganeti_tutorial::params::drbd8_utils_package_name

    package {
        "drbd8-utils":
            ensure  => installed,
            name    => $package_name,
    }

    file {
        "/etc/modules":
            ensure  => present,
            source  => "puppet:///modules/ganeti_tutorial/modules";
        "/etc/modprobe.d/local.conf":
            ensure  => present,
            source  => "puppet:///modules/ganeti_tutorial/modprobe.conf",
            notify  => Exec["modprobe_drbd"];
    }

    exec {
        "modprobe_drbd":
            command => "/sbin/modprobe drbd",
            creates => "/sys/module/drbd/parameters/usermode_helper",
            require => [
                File["/etc/modprobe.d/local.conf"],
                Package["drbd8-utils"], ],
    }

    service {
        "drbd":
           enable   => false,
           require  => Package["drbd8-utils"],
    }
}
