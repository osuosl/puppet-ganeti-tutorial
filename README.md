# Puppet Configs for a Ganeti Tutorial

This module is *not* intended for _production_ use and only used as an
_instructional tool_. It will setup two ganeti nodes with the basics to install
[Ganeti](http://code.google.com/p/ganeti/), [Ganeti Instance
Image](http://code.osuosl.org/projects/ganeti-image), and [Ganeti Web
Manager](http://code.osuosl.org/projects/ganeti-webmgr).

This module will be used for [Hands on Virtualization with
Ganeti](http://www.oscon.com/oscon2011/public/schedule/detail/18544) at [OSCON
2011](http://oscon.com).

# Requirements

This assumes that you have two Debian Squeeze VMs setup inside of VirtualBox.

# Steps

## Install Ganeti

    ./configure --localstatedir=/var --sysconfdir=/etc
    make && make install

## Install Instance Image

    ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc \
        --with-os-dir=/srv/ganeti/os
    make && make install

## Initialize Ganeti

    gnt-cluster init \
        --vg-name=ganeti \
        -s 192.168.16.15 \
        --master-netdev=br0 \
        -H kvm:nic_type=e1000,disk_type=scsi,vnc_bind_address=0.0.0.0 \
        ganeti.example.org

## Profit!

# Copyright

This work is licensed under a [Creative Commons Attribution-Share Alike 3.0
United States License](http://creativecommons.org/licenses/by-sa/3.0/us/).

vi: set tw=80 ft=markdown :
