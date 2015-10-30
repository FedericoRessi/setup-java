#!/bin/bash -e

# Copy configuration files
cp -fR /vagrant/provision/* /

# Verify integrity of bash profile
bash -e /etc/profile
