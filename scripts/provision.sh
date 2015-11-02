#!/bin/bash -e

# Copy configuration files
cp -fR /vagrant/setup_java/distrib_properties.sh /etc/profile.d

# Verify integrity of bash profile
bash -e /etc/profile
