#!/bin/bash -e

# Copy configuration files
cp -fR /vagrant/setup_java/distrib_properties.sh /etc/profile.d

source /etc/profile

if is_ubuntu; then
    sudo apt-get update -y
fi
