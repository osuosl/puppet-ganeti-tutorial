$host_ip = "33.33.33.12"
$drbd_ip = "33.33.34.12"
$git     = false
$ganeti_version = "2.5.1"

include ganeti_tutorial
include ganeti_tutorial::networking
include ganeti_tutorial::kvm
include ganeti_tutorial::instance_image
include ganeti_tutorial::ganeti::install
if $git {
    include ganeti_tutorial::ganeti::git
    Vcsrepo { provider => "git", }
}

File { owner => "root", group => "root", }
