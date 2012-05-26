$host_ip = "33.33.33.11"
$drbd_ip = "33.33.34.11"
$git     = false

include ganeti_tutorial
include ganeti_tutorial::networking
include ganeti_tutorial::kvm
include ganeti_tutorial::instance_image
include ganeti_tutorial::ganeti::install
include ganeti_tutorial::ganeti::initialize
if $git {
    include ganeti_tutorial::ganeti::git
    Vcsrepo { provider => "git", }
}

File { owner => "root", group => "root", }
