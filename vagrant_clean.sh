#!/bin/bash

######################################################################
# Script that prepares a CentOS 6 minimal VM for Vagrant packaging   #
# Install Vagrant plugin manually with:                              #
# vagrant plugin install vagrant-vbguest                             #
# to enable VirtualBox guest additions                               #
######################################################################

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
  else
    echo ":: Remove traces of mac address from network configuration"
    sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth*
    rm /etc/udev/rules.d/70-persistent-net.rules

    echo ":: Installing vagrant keys for ssh"
    wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
    chmod 0700 /home/vagrant/.ssh/
    chmod 0600 /home/vagrant/.ssh/authorized_keys
    chown -R vagrant:vagrant /home/vagrant/.ssh

    echo ":: yum clean"
    yum -y clean all

    echo ":: Zero out the free space to save space in the final image..."
    dd if=/dev/zero of=/EMPTY bs=1M
    rm -f /EMPTY
    sync
    poweroff
    echo ":: DONE!"
fi

